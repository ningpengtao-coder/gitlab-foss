<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import { s__ } from '~/locale';
import diffLineNoteFormMixin from 'ee_else_ce/notes/mixins/diff_line_note_form';
import noteForm from '../../notes/components/note_form.vue';
import { DIFF_NOTE_TYPE } from '../constants';

export default {
  components: {
    noteForm,
  },
  mixins: [diffLineNoteFormMixin],
  props: {
    diffFileHash: {
      type: String,
      required: true,
    },
    line: {
      type: Object,
      required: true,
    },
    linePosition: {
      type: String,
      required: false,
      default: '',
    },
    noteTargetLine: {
      type: Object,
      required: true,
    },
    helpPagePath: {
      type: String,
      required: false,
      default: '',
    },
  },
  computed: {
    ...mapState({
      noteableData: state => state.notes.noteableData,
      diffViewType: state => state.diffs.diffViewType,
    }),
    ...mapGetters('diffs', ['getDiffFileByHash']),
    ...mapGetters(['isLoggedIn', 'noteableType', 'getNoteableData', 'getNotesDataByProp']),
    formData() {
      return {
        noteableData: this.noteableData,
        noteableType: this.noteableType,
        noteTargetLine: this.noteTargetLine,
        diffViewType: this.diffViewType,
        diffFile: this.diffFile,
        linePosition: this.linePosition,
      };
    },
    diffFile() {
      return this.getDiffFileByHash(this.diffFileHash);
    },
    autosaveKey() {
      if (!this.isLoggedIn) return [];

      return [
        'Note',
        this.noteableType,
        this.noteableData.id,
        'new',
        this.noteableData.diff_head_sha,
        DIFF_NOTE_TYPE,
        this.noteableData.source_project_id,
        this.line.line_code,
      ];
    },
  },
  methods: {
    ...mapActions('diffs', ['cancelCommentForm', 'assignDiscussionsToDiff', 'saveDiffDiscussion']),
    handleCancelCommentForm(shouldConfirm, isDirty) {
      if (shouldConfirm && isDirty) {
        const msg = s__('Notes|Are you sure you want to cancel creating this comment?');

        // eslint-disable-next-line no-alert
        if (!window.confirm(msg)) {
          return;
        }
      }

      this.$refs.noteForm.clearDraft();

      this.cancelCommentForm({
        lineCode: this.line.line_code,
        fileHash: this.diffFileHash,
      });
    },
    handleSaveNote(note) {
      return this.saveDiffDiscussion({ note, formData: this.formData }).then(() =>
        this.handleCancelCommentForm(),
      );
    },
  },
};
</script>

<template>
  <div class="content discussion-form discussion-form-container discussion-notes">
    <note-form
      ref="noteForm"
      :is-editing="true"
      :line-code="line.line_code"
      :line="line"
      :help-page-path="helpPagePath"
      :diff-file="diffFile"
      save-button-title="Comment"
      class="diff-comment-form"
      :autosave-key="autosaveKey"
      @handleFormUpdateAddToReview="addToReview"
      @cancelForm="handleCancelCommentForm"
      @handleFormUpdate="handleSaveNote"
    />
  </div>
</template>
