<script>
import { visibilityOptions } from '~/pages/projects/shared/permissions/constants';

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
    tooltipData: function() {},
    title: function() {
      return this.$props.description;
    },
    iconClass: function() {
      const { level } = this.$props;
      if (level >= visibilityOptions.PUBLIC) return 'fa fa-globe fa-fw';
      else if (level >= visibilityOptions.INTERNAL) return 'fa fa-shield fa-fw';
      else return 'fa fa-lock fa-fw';
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
