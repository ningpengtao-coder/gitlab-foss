<script>
export default {
  props: {
    lineNumber: {
      type: Number,
      required: true,
    },
    path: {
      type: String,
      required: true,
    },
  },
  computed: {
    /**
     * Builds the url for each line number
     *
     * @returns String
     */
    buildLineNumber() {
      return `${this.path}#L${this.parsedLineNumber}`;
    },
    /**
     * Array indexes start with 0, so we add 1
     * to create the line number
     * @returns Number the line number
     */
    parsedLineNumber() {
      return this.lineNumber + 1;
    },

    lineNumberId() {
      return `L${this.lineNumber}`;
    }
  },
};
</script>
<template>
  <a class="line-number" :href="buildLineNumber" :id="lineNumberId">{{ parsedLineNumber }}</a>
</template>