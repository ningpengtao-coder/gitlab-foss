import _ from 'underscore';

export default {
  props: {
    isLoading: {
      type: Boolean,
      required: true,
    },
    pipeline: {
      type: Object,
      required: true,
    },
  },
  computed: {
    graph() {
      return this.pipeline.details && this.pipeline.details.stages;
    },
  },
  methods: {
    capitalizeStageName(name) {
      const escapedName = _.escape(name);
      return escapedName.charAt(0).toUpperCase() + escapedName.slice(1);
    },
    isFirstColumn(index) {
      return index === 0;
    },
    refreshPipelineGraph() {
      this.$emit('refreshPipelineGraph');
    },
    /**
     * CSS class is applied:
     *  - if pipeline graph contains only one stage column component
     *
     * @param {number} index
     * @returns {boolean}
     */
    shouldAddRightMargin(index) {
      return !(index === this.graph.length - 1);
    },
  },
};
