<script>
import Icon from '~/vue_shared/components/icon.vue';
import LineNumber from './job_log_line_number.vue';

export default {
  components: {
    LineNumber,
    Icon,
  },
  props: {
    line: {
      type: Object,
      required: false,
      default: () => {},
    },
    isClosed: {
      type: Boolean,
      required: true,
    },
    // duration: {
    //   type: String,
    //   required: false,
    //   default: null,
    // },
    currentPath: {
      type: String,
      required: true,
    },
  },

  computed: {
    iconName() {
      return this.isClosed ? 'angle-right' : 'angle-down';
    },
  },
  methods: {
    handleOnClick() {
      this.$emit('toggleLine');
    },
  },
};
</script>

<template>
  <div class="line collapsible-line" @click="handleOnClick" role="button">
    <icon :name="iconName" class="arrow" />
    <line-number :line-number="line.lineNumber" :path="currentPath" />
    <span v-for="(content, i) in line.content" :key="i" class="line-text">{{ content.text }}</span>
  </div>
</template>