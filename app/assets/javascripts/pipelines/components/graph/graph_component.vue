<script>
import { GlLoadingIcon } from '@gitlab/ui';
import StageColumnComponent from './stage_column_component.vue';
import GraphMixin from '../../mixins/graph_component_mixin';
import { debounceByAnimationFrame } from '~/lib/utils/common_utils';

let debouncedResize;
let sidebarMutationObserver;

export default {
  components: {
    StageColumnComponent,
    GlLoadingIcon,
  },
  mixins: [GraphMixin],
  data() {
    return {
      leftPadding: 0,
    };
  },
  beforeDestroy() {
    window.removeEventListener('resize', debouncedResize);

    if (sidebarMutationObserver) {
      sidebarMutationObserver.disconnect();
    }
  },
  created() {
    debouncedResize = debounceByAnimationFrame(this.setLeftPadding);
    window.addEventListener('resize', debouncedResize);
  },
  mounted() {
    this.setLeftPadding();

    sidebarMutationObserver = new MutationObserver(this.handleLayoutChange);
    sidebarMutationObserver.observe(document.querySelector('.layout-page'), {
      attributes: true,
      childList: false,
      subtree: false,
    });
  },
  methods: {
    setLeftPadding() {
      const container = document.querySelector('.content .container-limited');
      if (!container) return;
      this.leftPadding = container.offsetLeft;
    },
    handleLayoutChange() {
      // wait until animations finish, then recalculate padding
      window.setTimeout(this.setLeftPadding, 300);
    },
  },
};
</script>
<template>
  <div class="build-content middle-block js-pipeline-graph">
    <div class="pipeline-visualization pipeline-graph pipeline-tab-content">
      <div :style="{ paddingLeft: `${leftPadding}px` }">
        <div v-if="isLoading" class="m-auto"><gl-loading-icon :size="3" /></div>

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
