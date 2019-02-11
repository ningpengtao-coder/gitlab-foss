<script>
import updateMixin from '../../mixins/update';
import markdownField from '../../../vue_shared/components/markdown/field.vue';

export default {
  components: {
    markdownField,
  },
  mixins: [updateMixin],
  props: {
    formState: {
      type: Object,
      required: true,
    },
    markdownPreviewPath: {
      type: String,
      required: true,
    },
    markdownDocsPath: {
      type: String,
      required: true,
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
  },
  mounted() {
    this.$refs.textarea.focus();
  },
};
</script>

<template>
  <div class="common-note-form">
    <label class="sr-only" for="issue-description"> Description </label>
    <markdown-field
      ref="markdownField"
      v-model="formState.description"
      :markdown-preview-path="markdownPreviewPath"
      :markdown-docs-path="markdownDocsPath"
      :can-attach-file="canAttachFile"
      :enable-autocomplete="enableAutocomplete"
      textarea-id="issue-description"
      textarea-class="qa-description-textarea"
      :textarea-supports-quick-actions="false"
      :textarea-label="__('Description')"
      @save="updateIssuable"
    />
  </div>
</template>
