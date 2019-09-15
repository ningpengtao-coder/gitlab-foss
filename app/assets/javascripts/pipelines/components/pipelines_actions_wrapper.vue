<script>
import { GlTooltipDirective } from '@gitlab/ui';
import Icon from '../../vue_shared/components/icon.vue';

export default {
  components: {
    Icon,
  },
  directives: {
    GlTooltip: GlTooltipDirective,
  },
  data() {
    return {
      showActionButtons: false,
    };
  },
  methods: {
    toggleActionButtons() {
      this.$nextTick(() => {
        this.$root.$emit('bv::hide::tooltip');
      });

      this.showActionButtons = !this.showActionButtons;
    },
  },
};
</script>
<template>
  <div>
    <div
      class="btn-group table-action-buttons action-buttons-expanded d-flex d-md-none d-xl-inline-flex"
    >
      <slot name="action-buttons"></slot>
    </div>

    <div
      class="btn-group table-action-buttons action-buttons-toggleable d-none d-md-inline-flex d-xl-none"
    >
      <slot v-if="showActionButtons" name="action-buttons"></slot>
      <button
        v-gl-tooltip
        type="button"
        title="Actions"
        class="pipeline-action-button more-actions-toggle btn btn-transparent"
        @click="toggleActionButtons"
      >
        <icon css-classes="icon" name="ellipsis_v" />
      </button>
    </div>
  </div>
</template>
