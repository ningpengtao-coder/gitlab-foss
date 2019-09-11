<script>
import { __ } from '~/locale';
import { GlDropdown, GlDropdownItem, GlModalDirective, GlTooltipDirective } from '@gitlab/ui';
import Icon from '~/vue_shared/components/icon.vue';

export default {
  components: {
    Icon,
    GlDropdown,
    GlDropdownItem,
  },
  directives: {
    GlModal: GlModalDirective,
    GlTooltip: GlTooltipDirective,
  },
  props: {
    csvText: {
      type: String,
      required: false,
      default: null,
    },
    chartLink: {
      type: String,
      required: false,
      default: null,
    },
    alertModalId: {
      type: String,
      required: false,
      default: null,
    },
  },
  computed: {
    csvHref() {
      const data = new Blob([this.csvText], { type: 'text/plain' });
      return window.URL.createObjectURL(data);
    },
  },
  methods: {
    showToast() {
      this.$toast.show(__('Link copied to clipboard'));
    },
  },
};
</script>
<template>
  <gl-dropdown
    v-gl-tooltip
    class="mx-2"
    toggle-class="btn btn-transparent border-0"
    :right="true"
    :no-caret="true"
    :title="__('More actions')"
  >
    <template slot="button-content">
      <icon name="ellipsis_v" class="text-secondary" />
    </template>
    <gl-dropdown-item
      v-if="csvText"
      :href="csvHref"
      download="chart_metrics.csv"
      class="js-csv-dl-link"
    >
      {{ __('Download CSV') }}
    </gl-dropdown-item>
    <gl-dropdown-item
      v-if="chartLink"
      :data-clipboard-text="chartLink"
      class="js-chart-link"
      @click="showToast"
    >
      {{ __('Generate link to chart') }}
    </gl-dropdown-item>
    <gl-dropdown-item v-if="alertModalId" v-gl-modal="alertModalId" class="js-alert-link">
      {{ __('Alerts') }}
    </gl-dropdown-item>
  </gl-dropdown>
</template>
