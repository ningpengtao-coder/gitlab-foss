<script>
import { s__, sprintf } from '~/locale';
import Icon from '~/vue_shared/components/icon.vue';
// TODO: should this poll for latest status?

// - status            = local_assigns.fetch(:status)
// - size              = local_assigns.fetch(:size, 16)
// - type              = local_assigns.fetch(:type, 'pipeline')
// - tooltip_placement = local_assigns.fetch(:tooltip_placement, "left")
// - path              = local_assigns.fetch(:path, status.has_details? ? status.details_path : nil)

export default {
  components: {
    Icon,
  },
  props: {
    status: {
      type: String,
      required: true,
    },
    // setup the path in the higher level?
    path: {
      type: String,
      default: null,
    },
    iconSize: {
      type: Number,
      default: 16,
    },
    iconName: {
      type: Number,
      default: 16,
    },
    type: {
      type: String,
      default: 'pipeline',
    },
    group: {
      type: String,
      required: true,
    },
    tooltipPlacement: {
      type: String,
      default: 'left',
    },
  },
  data() {},
  computed: {
    title() {
      const pipelineType = this.type === 'Commit' ? 'Commit' : 'Pipeline';
      return sprintf(s__(`PipelineStatusTooltip|${pipelineType}: ${this.ci_status}`));
    },
    icon() {
      return this.iconName;
    },
    cssClasses() {
      const { group } = this;
      return `ci-status-link ci-status-icon ci-status-icon-${group} has-tooltip`;
    },
    hasPath() {
      return !!this.path;
    },
  },
};
</script>
<template>
  <div class="icon-wrapper pipeline-status">
    <span class="{{cssClasses}}" :title="title" data-placement="{{tooltipPlacement}}">
      <icon :name="iconName" :size="size" css-classes="append-right-4"/>
    </span>
  </div>
</template>
