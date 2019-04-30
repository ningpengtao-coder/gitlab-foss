<script>
import { visibilityOptions } from '~/pages/projects/shared/permissions/constants';

export const visibilityIconClass = (level = -1) => {
  if (level < visibilityOptions.INTERNAL) return 'fa-lock';
  else if (level < visibilityOptions.PUBLIC) return 'fa-shield';
  else return 'fa-globe';
};

export default {
  props: {
    level: {
      // TODO: not sure what to default to, private?
      type: Number,
      default: visibilityOptions.PRIVATE,
    },
    description: {
      type: String,
      default: '',
    },
  },
  computed: {
    title: function() {
      return this.$props.description;
    },
    iconClass: function() {
      const { level = null } = this.$props;
      return `fa ${visibilityIconClass(level)} fa-fw`;
    },
  },
};
</script>
<template>
  <span
    class="metadata-info visibility-icon append-right-10 prepend-top-8 has-tooltip"
    data-container="body"
    data-placement="top"
    :title="title"
  >
    <!-- TODO: should this be SVG? -->
    <i aria-hidden="true" data-hidden="true" :class="iconClass"></i>
  </span>
</template>
