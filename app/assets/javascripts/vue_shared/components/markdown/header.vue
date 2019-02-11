<script>
import $ from 'jquery';
import { GlTooltipDirective } from '@gitlab/ui';
import ToolbarButton from './toolbar_button.vue';
import Icon from '../icon.vue';

export default {
  components: {
    ToolbarButton,
    Icon,
  },
  directives: {
    GlTooltip: GlTooltipDirective,
  },
  props: {
    mode: {
      type: String,
      required: true,
    },
    lineContent: {
      type: String,
      required: false,
      default: '',
    },
    canSuggest: {
      type: Boolean,
      required: false,
      default: true,
    },
  },
  computed: {
    modeIsMarkdown() {
      return this.mode === 'markdown';
    },
    modeIsPreview() {
      return this.mode === 'preview';
    },
    mdTable() {
      return [
        '| header | header |',
        '| ------ | ------ |',
        '| cell | cell |',
        '| cell | cell |',
      ].join('\n');
    },
    mdSuggestion() {
      return ['```suggestion:-0+0', `{text}`, '```'].join('\n');
    },
  },
  mounted() {
    $(document).on('markdown-preview:show.vue', this.previewTab);
    $(document).on('markdown-preview:hide.vue', this.markdownTab);
  },
  beforeDestroy() {
    $(document).off('markdown-preview:show.vue', this.previewTab);
    $(document).off('markdown-preview:hide.vue', this.markdownTab);
  },
  methods: {
    isValid(form) {
      return (
        !form ||
        (form.find('.js-vue-markdown-field').length && $(this.$el).closest('form')[0] === form[0])
      );
    },

    previewTab(event, form) {
      if (event.target.blur) event.target.blur();
      if (!this.isValid(form)) return;

      this.$emit('mode-changed', 'preview');
    },

    markdownTab(event, form) {
      if (event.target.blur) event.target.blur();
      if (!this.isValid(form)) return;

      this.$emit('mode-changed', 'markdown');
    },
  },
};
</script>

<template>
  <div class="md-header">
    <ul class="nav-links clearfix">
      <li :class="{ active: modeIsMarkdown }" class="md-header-tab">
        <button class="js-write-link" tabindex="-1" type="button" @click="markdownTab($event)">
          {{ __('Write') }}
        </button>
      </li>
      <li :class="{ active: modeIsPreview }" class="md-header-tab">
        <button class="js-preview-link" tabindex="-1" type="button" @click="previewTab($event)">
          {{ __('Preview') }}
        </button>
      </li>
      <li :class="{ active: !modeIsPreview }" class="md-header-toolbar">
        <toolbar-button tag="**" button-title="__('Add bold text')" icon="bold" />
        <toolbar-button tag="*" button-title="__('Add italic text')" icon="italic" />
        <toolbar-button
          :prepend="true"
          tag="> "
          :button-title="__('Insert a quote')"
          icon="quote"
        />
        <toolbar-button tag="`" tag-block="```" button-title="__('Insert code')" icon="code" />
        <toolbar-button
          tag="[{text}](url)"
          tag-select="url"
          :button-title="__('Add a link')"
          icon="link"
        />
        <toolbar-button
          :prepend="true"
          tag="* "
          :button-title="__('Add a bullet list')"
          icon="list-bulleted"
        />
        <toolbar-button
          :prepend="true"
          tag="1. "
          :button-title="__('Add a numbered list')"
          icon="list-numbered"
        />
        <toolbar-button
          :prepend="true"
          tag="* [ ] "
          :button-title="__('Add a task list')"
          icon="task-done"
        />
        <toolbar-button
          :tag="mdTable"
          :prepend="true"
          :button-title="__('Add a table')"
          icon="table"
        />
        <toolbar-button
          v-if="canSuggest"
          :tag="mdSuggestion"
          :prepend="true"
          :button-title="__('Insert suggestion')"
          :cursor-offset="4"
          :tag-content="lineContent"
          icon="doc-code"
          class="qa-suggestion-btn"
        />
        <button
          v-gl-tooltip
          :aria-label="__('Go full screen')"
          class="toolbar-btn toolbar-fullscreen-btn js-zen-enter"
          data-container="body"
          tabindex="-1"
          :title="__('Go full screen')"
          type="button"
        >
          <icon name="screen-full" />
        </button>
      </li>
    </ul>
  </div>
</template>
