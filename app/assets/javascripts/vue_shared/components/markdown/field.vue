<script>
import $ from 'jquery';
import _ from 'underscore';
import Autosave from '~/autosave';
import Autosize from 'autosize';
import { Editor, EditorContent } from 'tiptap';
import { Placeholder, History } from 'tiptap-extensions';
import { DOMParser } from 'prosemirror-model';
import { TextSelection } from 'prosemirror-state';
import { __ } from '~/locale';
import { stripHtml } from '~/lib/utils/text_utility';
import Flash from '../../../flash';
import markdownHeader from './header.vue';
import markdownToolbar from './toolbar.vue';
import icon from '../icon.vue';
import Suggestions from '~/vue_shared/components/markdown/suggestions.vue';
import { updateText } from '~/lib/utils/text_markdown';
import GfmAutoComplete, * as GFMConfig from '~/gfm_auto_complete';
import dropzoneInput from '~/dropzone_input';
import editorExtensions from '~/behaviors/markdown/editor_extensions';
import markdownSerializer from '~/behaviors/markdown/serializer';
import { UP_KEY_CODE, ENTER_KEY_CODE, ESC_KEY_CODE } from '~/lib/utils/keycodes';

export default {
  components: {
    EditorContent,
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
  },
  data() {
    return {
      isFocused: false,
      mode: 'markdown',
      autosave: null,
      autocomplete: null,
      dropzone: null,
      editor: null,
      currentValue: this.value,
      editorContent: null,
      editorContentOutdated: true,
      renderedLoading: false,
      renderedValue: null,
      rendered: '',
      referencedCommands: '',
      referencedUsers: '',
      hasSuggestion: false,
    };
  },
  computed: {
    renderedOutdated() {
      return this.currentValue !== this.renderedValue;
    },
    needsMarkdownRender() {
      return (
        this.renderedOutdated &&
        ((this.mode === 'rich' && this.editorContentOutdated) || this.mode === 'preview')
      );
    },
    needsPreviewGFMRender() {
      return !this.renderedOutdated && this.mode === 'preview';
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
    suggestions() {
      return this.note.suggestions || [];
    },
    lineType() {
      return this.line ? this.line.type : '';
    },
  },
  watch: {
    mode() {
      this.$nextTick(() => {
        this.focus();

        if (this.mode === 'markdown') {
          this.autosizeTextarea();
        }
      });
    },
    needsMarkdownRender() {
      if (this.needsMarkdownRender) {
        this.$nextTick(this.renderMarkdown);
      }
    },
    renderedOutdated() {
      if (!this.renderedOutdated) {
        this.editorContent = this.rendered;
      }
    },
    needsPreviewGFMRender() {
      if (this.needsPreviewGFMRender) {
        this.$nextTick(this.renderPreviewGFM);
      }
    },
    editorContentOutdated() {
      if (this.editorContentOutdated) {
        if (this.renderedOutdated) {
          this.editor.clearContent();
          this.editorContent = null;
        } else {
          this.editorContent = this.rendered;
        }
      }
    },
    editorContent() {
      if (this.editorContentOutdated && this.editorContent !== null) {
        this.editor.setContent(this.editorContent);
        this.editorContentOutdated = false;
      }
    },
    value() {
      this.setCurrentValue(this.value, { emitEvent: false });
    },
    currentValue() {
      if (this.autosave) {
        this.$nextTick(this.autosave.save);
      }

      if (this.mode === 'markdown') {
        this.$nextTick(this.autosizeTextarea);
      }
    },
  },
  mounted() {
    this.editor = this.createEditor();

    if (this.autosaveKey.length) {
      this.autosave = new Autosave($(this.$refs.textarea), this.autosaveKey);
    }

    if (this.enableAutocomplete) {
      this.autocomplete = this.setupAutocomplete();
    }

    this.dropzone = dropzoneInput($(this.$refs.glForm));

    Autosize(this.$refs.textarea);
    this.autosizeTextarea();
  },
  beforeDestroy() {
    this.editor.destroy();

    if (this.autosave) {
      this.autosave.reset();
      this.autosave.dispose();
    }

    if (this.autocomplete) {
      this.autocomplete.destroy();
    }

    if (this.dropzone) {
      this.dropzone.disable();
    }

    Autosize.destroy(this.$refs.textarea);
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

    createEditor() {
      return new Editor({
        useBuiltInExtensions: false,
        extensions: [
          ...editorExtensions,

          new History(),
          new Placeholder({
            emptyClass: 'is-empty',
            emptyNodeText: 'Write a comment here…',
          }),
        ],
        editable: this.editable,
        onInit: ({ view }) =>
          $(view.dom)
            .addClass('md md-preview')
            .on('keydown', this.onEditorKeydown),
        onFocus: () => this.isFocused = true,
        onBlur: () => this.isFocused = false,
        onUpdate: this.onEditorUpdate,
      });
    },

    setCurrentValue(newValue, { editorContentOutdated = true, emitEvent = true } = {}) {
      if (newValue === this.currentValue) return;

      this.editorContentOutdated = editorContentOutdated;
      this.currentValue = newValue;

      if (emitEvent) {
        this.$emit('input', this.currentValue);
      }
    },

    quoteNode(node) {
      const blockquoteEl = document.createElement('blockquote');
      blockquoteEl.appendChild(node.cloneNode(true));

      const wrapEl = document.createElement('div');
      wrapEl.appendChild(blockquoteEl);
      const quoteDoc = DOMParser.fromSchema(this.editor.schema).parse(wrapEl);

      this.appendDocToValue(quoteDoc);

      this.$nextTick(this.focus);
    },

    appendDocToValue(appendableDoc) {
      if (this.mode === 'rich') {
        const { view, schema } = this.editor;
        const { state } = view;
        const { doc, tr } = state;
        const endPos = doc.content.size;

        // Add empty paragraph to end
        tr.insert(endPos, schema.nodes.paragraph.create());

        let replaceStart = endPos;
        const { lastChild } = doc;
        // If the last child is an empty paragraph, we want to replace it
        if (lastChild.type.name === 'paragraph' && lastChild.content.size === 0) {
          replaceStart -= lastChild.nodeSize;
        }

        // Add quote node just before empty paragraph
        tr.replaceWith(replaceStart, endPos, appendableDoc);

        view.dispatch(tr);
      } else {
        const markdown = markdownSerializer.serialize(appendableDoc);

        const current = this.currentValue.trim();
        const separator = current.length ? '\n\n' : '';
        this.setCurrentValue(`${current}${separator}${markdown}\n\n`);
      }
    },

    blur() {
      if (this.mode === 'markdown') {
        this.$refs.textarea.blur();
      }
    },

    focus() {
      switch (this.mode) {
        case 'markdown':
          this.$refs.textarea.focus();
          break;
        case 'rich': {
          const { view } = this.editor;
          const { state } = view;
          const { doc } = state;

          // Move cursor to end
          const endPos = doc.resolve(doc.content.size);
          view.dispatch(state.tr.setSelection(TextSelection.between(endPos, endPos)));

          this.editor.focus();
          break;
        }
        default:
          break;
      }
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
      }

      this.renderedLoading = false;
      this.renderedValue = text;

      if (this.mode === 'rich') {
        this.$nextTick(this.focus);
      }
    },

    renderPreviewGFM() {
      $(this.$refs.markdownPreview).renderGFM();
    },

    autosizeTextarea() {
      Autosize.update(this.$refs.textarea);
    },

    toolbarButtonClicked(button) {
      if (this.mode === 'markdown') {
        updateText({
          textArea: this.$refs.textarea,
          tag: button.tag,
          blockTag: button.tagBlock,
          wrap: !button.prepend,
          select: button.tagSelect,
          cursorOffset: button.cursorOffset,
          tagContent: button.tagContent,
        });
      } else {
        const { commands, view, schema, isActive } = this.editor;

        switch (button.name) {
          case 'code':
            if (isActive.code()) {
              commands.code();
            } else if (isActive.code_block()) {
              commands.code_block();
            } else {
              const selectionFragment = view.state.selection.content().content;
              const selectionDoc = schema.nodes.doc.create({}, selectionFragment);
              const selectionMarkdown = markdownSerializer.serialize(selectionDoc);
              if (selectionMarkdown.indexOf('\n') === -1) {
                commands.code();
              } else {
                commands.code_block();
              }
            }
            break;
          case 'suggestion':
            if (isActive.code_block()) {
              commands.code_block();
            } else {
              commands.code_block({ lang: 'suggestion' });
              if (view.state.selection.empty) {
                view.dispatch(view.state.tr.insertText(button.tagContent));
              }
            }
            break;
          default: {
            const command = commands[button.name];
            if (command) command();
            break;
          }
        }
      }
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

    onEditorUpdate({ state: { doc } }) {
      this.editorContent = doc.toJSON();
      this.setCurrentValue(markdownSerializer.serialize(doc), { editorContentOutdated: false });
    },

    onEditorKeydown(e) {
      switch (e.keyCode) {
        case UP_KEY_CODE:
          this.triggerEditPrevious();
          break;
        case ENTER_KEY_CODE:
          if (e.metaKey || e.ctrlKey) {
            e.preventDefault();
            this.triggerSave();
          }
          break;
        case ESC_KEY_CODE:
          e.preventDefault();
          this.triggerCancel();
          break;
        default:
          break;
      }
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
    class="md-area js-vue-markdown-field"
  >
    <markdown-header
      :line-content="lineContent"
      :can-suggest="canSuggest"
      :mode="mode"
      @preview="mode = 'preview'"
      @markdown="mode = 'markdown'"
      @rich="mode = 'rich'"
      @toolbar-button-clicked="toolbarButtonClicked"
    />
    <div v-show="mode === 'markdown'" class="md-write-holder">
      <div :class="{ 'div-dropzone-wrapper': true, 'zen-backdrop': mode === 'markdown' }">
        <textarea
          :id="textareaId"
          ref="textarea"
          placeholder="Write a comment or drag your files here…"
          :value="currentValue"
          :name="textareaName"
          :class="['note-textarea markdown-area js-gfm-input js-vue-textarea', textareaClass]"
          :data-supports-quick-actions="textareaSupportsQuickActions"
          :aria-label="textareaLabel"
          :disabled="!editable"
          @keydown.up="triggerEditPrevious"
          @keydown.meta.enter="triggerSave"
          @keydown.ctrl.enter="triggerSave"
          @keydown.esc="triggerCancel"
          @input="onTextareaInput"
          @focus="isFocused = true"
          @blur="isFocused = false"
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

    <div v-show="mode === 'rich'" class="md-rich-holder">
      <div :class="{ 'md-rich-editor': true, 'zen-backdrop': mode === 'rich' }">
        <editor-content v-show="!editorContentOutdated" :editor="editor" class="editor" />
        <span v-if="editorContentOutdated">
          {{ __('Loading…') }}
        </span>
      </div>

      <a class="zen-control zen-control-leave js-zen-leave" href="#" aria-label="Exit zen mode">
        <icon :size="32" name="screen-normal" />
      </a>
      <markdown-toolbar :rich-text="true" :can-attach-file="false" />
    </div>

    <div v-show="mode === 'preview'" class="js-vue-md-preview md-preview-holder">
      <span v-if="renderedOutdated">
        {{ __('Loading…') }}
      </span>
      <span v-else-if="rendered.length === 0">
        Nothing to preview
      </span>
      <template v-else-if="hasSuggestion">
        <div ref="markdownPreview" class="md md-preview">
          <suggestions
            v-if="hasSuggestion"
            :note-html="rendered"
            :from-line="lineNumber"
            :from-content="lineContent"
            :line-type="lineType"
            :disabled="true"
            :suggestions="suggestions"
            :help-page-path="helpPagePath"
          />
        </div>
      </template>
      <template v-else>
        <div ref="markdownPreview" class="md md-preview" v-html="rendered"></div>
      </template>
    </div>

    <template v-if="mode === 'preview' && !renderedOutdated">
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
