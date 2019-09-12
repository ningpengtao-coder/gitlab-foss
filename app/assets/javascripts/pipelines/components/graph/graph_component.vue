<script>
import { GlLoadingIcon } from '@gitlab/ui';
import StageColumnComponent from './stage_column_component.vue';
import GraphMixin from '../../mixins/graph_component_mixin';
import { debounceByAnimationFrame } from '~/lib/utils/common_utils';
import { LAYOUT_CHANGE_DELAY } from '~/pipelines/constants';

export default {
  components: {
    StageColumnComponent,
    GlLoadingIcon,
  },
  mixins: [GraphMixin],
  debouncedResize: null,
  sidebarMutationObserver: null,
  data() {
    return {
      graphLeftPadding: 0,
      graphRightPadding: 0,
    };
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.$options.debouncedResize);

    if (this.$options.sidebarMutationObserver) {
      this.$options.sidebarMutationObserver.disconnect();
    }
  },
  created() {
    this.$options.debouncedResize = debounceByAnimationFrame(this.setGraphPadding);
    window.addEventListener('resize', this.$options.debouncedResize);
  },
  mounted() {
    this.setGraphPadding();

    this.$options.sidebarMutationObserver = new MutationObserver(this.handleLayoutChange);
    this.$options.sidebarMutationObserver.observe(document.querySelector('.layout-page'), {
      attributes: true,
      childList: false,
      subtree: false,
    });
  },
  methods: {
    setGraphPadding() {
      const container = document.querySelector('.js-pipeline-container');
      if (!container) return;

      this.graphLeftPadding = container.offsetLeft;
      this.graphRightPadding = window.innerWidth - container.offsetLeft - container.offsetWidth;
    },
    handleLayoutChange() {
      // wait until animations finish, then recalculate padding
      window.setTimeout(this.setGraphPadding, LAYOUT_CHANGE_DELAY);
    },
  },
};
</script>
<template>
  <div class="build-content middle-block js-pipeline-graph">
    <div class="pipeline-visualization pipeline-graph pipeline-tab-content">
      <div
        :style="{
          paddingLeft: `${graphLeftPadding}px`,
          paddingRight: `${graphRightPadding}px`,
        }"
      >
        <gl-loading-icon v-if="isLoading" class="m-auto" :size="3" />

        <ul v-if="!isLoading" class="stage-column-list">
          <stage-column-component
            v-for="(stage, index) in graph"
            :key="stage.name"
            :class="{
              'append-right-48': shouldAddRightMargin(index),
            }"
            :title="capitalizeStageName(stage.name)"
            :groups="stage.groups"
            :stage-connector-class="stageConnectorClass(index, stage)"
            :is-first-column="isFirstColumn(index)"
            :action="stage.status.action"
            @refreshPipelineGraph="refreshPipelineGraph"
          />
        </ul>
      </div>
    </div>
  </div>
</template>
