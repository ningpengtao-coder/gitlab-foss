<script>
import $ from 'jquery';
import _ from 'underscore';
import { getDraft, updateDraft, clearDraft } from '~/lib/utils/autosave';
import Autosize from 'autosize';
import { __ } from '~/locale';
import { stripHtml } from '~/lib/utils/text_utility';
import Flash from '../../../flash';
import { CopyAsGFM } from '~/behaviors/markdown/copy_as_gfm';
import eventHub from '~/behaviors/markdown/event_hub';
import markdownHeader from './header.vue';
import markdownToolbar from './toolbar.vue';
import icon from '../icon.vue';
import Suggestions from '~/vue_shared/components/markdown/suggestions.vue';
import { updateText } from '~/lib/utils/text_markdown';
import GfmAutoComplete, * as GFMConfig from '~/gfm_auto_complete';
import dropzoneInput from '~/dropzone_input';

export default {
  components: {
    markdownHeader,
    markdownToolbar,
    icon,
    Suggestions,
  },
  props: {
    value: {
      type: String,
      required: false,
      default: '',
    },
    markdownPreviewPath: {
      type: String,
      required: false,
      default: '',
    },
    markdownDocsPath: {
      type: String,
      required: true,
    },
    addSpacingClasses: {
      type: Boolean,
      required: false,
      default: true,
    },
    quickActionsDocsPath: {
      type: String,
      required: false,
      default: '',
    },
    canAttachFile: {
      type: Boolean,
      required: false,
      default: true,
    },
    enableAutocomplete: {
      type: Boolean,
      required: false,
      default: true,
    },
    line: {
      type: Object,
      required: false,
      default: null,
    },
    note: {
      type: Object,
      required: false,
      default: () => ({}),
    },
    canSuggest: {
      type: Boolean,
      required: false,
      default: false,
    },
    helpPagePath: {
      type: String,
      required: false,
      default: '',
    },
    editable: {
      type: Boolean,
      required: false,
      default: true,
    },
    autosaveKey: {
      type: Array,
      required: false,
      default: () => [],
    },
    textareaId: {
      type: String,
      required: false,
      default: '',
    },
    textareaName: {
      type: String,
      required: false,
      default: '',
    },
    textareaClass: {
      type: String,
      required: false,
      default: '',
    },
    textareaSupportsQuickActions: {
      type: Boolean,
      required: false,
      default: false,
    },
    textareaLabel: {
      type: String,
      required: false,
      default: '',
    },
    subscribeToGlobalEvents: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  data() {
    return {
      isFocused: false,
      mode: 'markdown',
      autocomplete: null,
      dropzone: null,
      currentValue: this.value,
      renderedLoading: false,
      renderedValue: null,
      rendered: '',
      referencedCommands: '',
      referencedUsers: '',
      hasSuggestion: false,
      suggestions: this.note.suggestions || [],
    };
  },
  computed: {
    modeIsMarkdown() {
      return this.mode === 'markdown';
    },
    modeIsPreview() {
      return this.mode === 'preview';
    },
    renderedOutdated() {
      return this.currentValue !== this.renderedValue;
    },
    needsMarkdownRender() {
      return this.renderedOutdated && this.modeIsPreview;
    },
    needsPreviewGFMRender() {
      return !this.renderedOutdated && this.modeIsPreview;
    },
    shouldShowReferencedUsers() {
      const referencedUsersThreshold = 10;
      return this.referencedUsers.length >= referencedUsersThreshold;
    },
    lineContent() {
      const [firstSuggestion] = this.suggestions;
      if (firstSuggestion) {
        return firstSuggestion.from_content;
      }

      if (this.line) {
        const { rich_text: richText, text } = this.line;

        if (text) {
          return text;
        }

        return _.unescape(stripHtml(richText).replace(/\n/g, ''));
      }

      return '';
    },
    lineNumber() {
      let lineNumber;
      if (this.line) {
        const { new_line: newLine, old_line: oldLine } = this.line;
        lineNumber = newLine || oldLine;
      }
      return lineNumber;
    },
    lineType() {
      return this.line ? this.line.type : '';
    },
  },
  watch: {
    mode() {
      this.$nextTick(() => {
        this.focus();

        if (this.modeIsMarkdown) {
          this.autosizeTextarea();
        }
      });
    },
    needsMarkdownRender() {
      if (this.needsMarkdownRender) {
        this.$nextTick(this.renderMarkdown);
      }
    },
    needsPreviewGFMRender() {
      if (this.needsPreviewGFMRender) {
        this.$nextTick(this.renderPreviewGFM);
      }
    },
    value() {
      this.setCurrentValue(this.value, { emitEvent: false });
    },
    currentValue() {
      if (this.autosaveKey.length) {
        updateDraft(this.autosaveKey, this.currentValue);
      }

      if (this.modeIsMarkdown) {
        this.$nextTick(this.autosizeTextarea);
      }
    },
  },
  mounted() {
    if (this.autosaveKey.length) {
      const draft = getDraft(this.autosaveKey);

      if (draft && draft.length) {
        this.setCurrentValue(draft);
      }
    }

    if (this.enableAutocomplete) {
      this.autocomplete = this.setupAutocomplete();
    }

    this.dropzone = dropzoneInput($(this.$refs.glForm));

    Autosize(this.$refs.textarea);
    this.autosizeTextarea();

    if (this.subscribeToGlobalEvents) {
      eventHub.$on('focus', this.focusIfVisible);
      eventHub.$on('quoteNode', this.quoteNodeIfVisible);
    }
  },
  beforeDestroy() {
    if (this.autocomplete) {
      this.autocomplete.destroy();
    }

    if (this.dropzone) {
      this.dropzone.disable();
    }

    Autosize.destroy(this.$refs.textarea);

    if (this.subscribeToGlobalEvents) {
      eventHub.$off('focus', this.focusIfVisible);
      eventHub.$off('quoteNode', this.quoteNodeIfVisible);
    }
  },
  methods: {
    setupAutocomplete() {
      const autocompleteConfig = Object.assign({}, GFMConfig.defaultAutocompleteConfig);
      const dataSources = (gl.GfmAutoComplete && gl.GfmAutoComplete.dataSources) || {};

      // Disable autocomplete for keywords which do not have dataSources available
      Object.keys(autocompleteConfig).forEach(item => {
        if (item !== 'emojis') {
          autocompleteConfig[item] = autocompleteConfig[item] && !!dataSources[item];
        }
      });

      const autocomplete = new GfmAutoComplete(dataSources);
      autocomplete.setup($(this.$refs.textarea), autocompleteConfig);
      return autocomplete;
    },

    setMode(newMode) {
      this.mode = newMode;
    },

    setFocused(newFocused) {
      this.isFocused = newFocused;
    },

    setCurrentValue(newValue, { emitEvent = true } = {}) {
      if (newValue === this.currentValue) return;

      this.currentValue = newValue;

      if (emitEvent) {
        this.$emit('input', this.currentValue);
      }
    },

    clear() {
      this.setCurrentValue('');
      this.clearDraft();
      this.switchToEditor();
    },

    clearDraft() {
      if (this.autosaveKey.length) {
        clearDraft(this.autosaveKey);
      }
    },

    switchToEditor() {
      if (this.modeIsPreview) {
        this.setMode('markdown');
      }
    },

    quoteNode(node) {
      const blockquoteEl = document.createElement('blockquote');
      blockquoteEl.appendChild(node.cloneNode(true));

      const current = this.currentValue.trim();
      const separator = current.length ? '\n\n' : '';

      CopyAsGFM.nodeToGFM(blockquoteEl)
        .then(markdown => this.setCurrentValue(`${current}${separator}${markdown}\n\n`))
        .then(this.switchToEditor)
        .then(this.$nextTick)
        .then(this.focus)
        .catch(() => {});
    },

    ifVisible(func) {
      if ($(this.$el).is(':visible')) {
        func();
      }
    },

    quoteNodeIfVisible(node) {
      this.ifVisible(() => this.quoteNode(node));
    },

    blur() {
      if (this.modeIsMarkdown) {
        this.$refs.textarea.blur();
      }
    },

    focus() {
      if (this.modeIsMarkdown) {
        this.$refs.textarea.focus();
      }
    },

    focusIfVisible() {
      this.ifVisible(this.focus);
    },

    renderMarkdown() {
      if (!this.renderedOutdated || this.renderedLoading) return;

      const text = this.currentValue;

      if (text.length) {
        this.renderedLoading = true;
        this.$http
          .post(this.markdownPreviewPath, { text })
          .then(resp => resp.json())
          .then(data => this.updateRendered(text, data))
          .catch(() => new Flash(__('Error rendering markdown')));
      } else {
        this.updateRendered(text);
      }
    },

    updateRendered(text, data = {}) {
      this.rendered = data.body || '';

      if (data.references) {
        this.referencedCommands = data.references.commands;
        this.referencedUsers = data.references.users;
        this.hasSuggestion = data.references.suggestions && data.references.suggestions.length;
        this.suggestions = data.references.suggestions;
      }

      this.renderedLoading = false;
      this.renderedValue = text;
    },

    renderPreviewGFM() {
      $(this.$refs.markdownPreview).renderGFM();
    },

    autosizeTextarea() {
      Autosize.update(this.$refs.textarea);
    },

    toolbarButtonClicked(button) {
      updateText({
        textArea: this.$refs.textarea,
        tag: button.tag,
        blockTag: button.tagBlock,
        wrap: !button.prepend,
        select: button.tagSelect,
        cursorOffset: button.cursorOffset,
        tagContent: button.tagContent,
      });
    },

    triggerEditPrevious() {
      if (!this.currentValue.length) this.$emit('edit-previous');
    },

    triggerSave() {
      this.$emit('save');
    },

    triggerCancel() {
      this.$emit('cancel');
    },

    onTextareaInput() {
      this.setCurrentValue(this.$refs.textarea.value);
    },
  },
};
</script>

<template>
  <div
    ref="glForm"
    :class="{
      'prepend-top-default append-bottom-default': addSpacingClasses,
      'is-focused': isFocused,
    }"
    class="js-vue-markdown-field md-area position-relative"
  >
    <markdown-header
      :line-content="lineContent"
      :can-suggest="canSuggest"
      :mode="mode"
      @mode-changed="setMode"
      @toolbar-button-clicked="toolbarButtonClicked"
    />
    <div v-show="modeIsMarkdown" class="md-write-holder">
      <div class="div-dropzone-wrapper" :class="{ 'zen-backdrop': modeIsMarkdown }">
        <textarea
          :id="textareaId"
          ref="textarea"
          placeholder="Write a comment or drag your files here…"
          dir="auto"
          :value="currentValue"
          :name="textareaName"
          class="note-textarea markdown-area js-gfm-input js-vue-textarea"
          :class="textareaClass"
          :data-supports-quick-actions="textareaSupportsQuickActions"
          :aria-label="textareaLabel"
          :disabled="!editable"
          @keydown.up="triggerEditPrevious"
          @keydown.meta.enter="triggerSave"
          @keydown.ctrl.enter="triggerSave"
          @keydown.esc="triggerCancel"
          @input="onTextareaInput"
          @focus="setFocused(true)"
          @blur="setFocused(false)"
        >
        </textarea>

        <a class="zen-control zen-control-leave js-zen-leave" href="#" aria-label="Exit zen mode">
          <icon :size="32" name="screen-normal" />
        </a>
        <markdown-toolbar
          :markdown-docs-path="markdownDocsPath"
          :quick-actions-docs-path="quickActionsDocsPath"
          :can-attach-file="canAttachFile"
        />
      </div>
    </div>

    <div v-show="modeIsPreview" ref="markdownPreview" class="js-vue-md-preview md-preview-holder">
      <span v-if="renderedOutdated">
        {{ __('Loading…') }}
      </span>
      <span v-else-if="rendered.length === 0">
        {{ __('Nothing to preview.') }}
      </span>
      <suggestions
        v-else-if="hasSuggestion"
        :note-html="rendered"
        :from-line="lineNumber"
        :from-content="lineContent"
        :line-type="lineType"
        :disabled="true"
        :suggestions="suggestions"
        :help-page-path="helpPagePath"
      />
      <div v-else class="md" v-html="rendered"></div>
    </div>

    <template v-if="modeIsPreview && !renderedOutdated">
      <div v-if="referencedCommands" class="referenced-commands" v-html="referencedCommands"></div>
      <div v-if="shouldShowReferencedUsers" class="referenced-users">
        <span>
          <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> You are about to add
          <strong>
            <span class="js-referenced-users-count">{{ referencedUsers.length }}</span>
          </strong>
          people to the discussion. Proceed with caution.
        </span>
      </div>
    </template>
  </div>
</template>
