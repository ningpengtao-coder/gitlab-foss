<script>
export default {
  props: {
    modalConfiguration: {
      required: true,
      type: Map,
    },
    actionModals: {
      required: true,
      type: Map,
    },
    csrfToken: {
      required: true,
      type: String,
    },
  },
  data() {
    return {
      currentModalData: null,
    };
  },
  computed: {
    activeModal() {
      if (!this.currentModalData) return null;
      const { glModalAction: action } = this.currentModalData;

      return this.actionModals.get(action);
    },

    modalProps() {
      const { glModalAction: requestedAction } = this.currentModalData;
      return {
        ...this.modalConfiguration.get(requestedAction),
        ...this.currentModalData,
        csrfToken: this.csrfToken,
      };
    },
  },

  mounted() {
    document.addEventListener('click', this.handleClick);
  },

  beforeDestroy() {
    document.removeEventListener('click', this.handleClick);
  },

  methods: {
    handleClick(e) {
      const { glModalAction: action } = e.target.dataset;
      if (!action) return;

      this.show(e.target.dataset);
      e.preventDefault();
    },

    show(modalData) {
      const { glModalAction: requestedAction } = modalData;
      if (!this.actionModals.has(requestedAction)) {
        throw new Error(`Requested non-existing modal action ${requestedAction}`);
      }
      if (!this.modalConfiguration.has(requestedAction)) {
        throw new Error(`Modal action ${requestedAction} has no configuration in HTML`);
      }

      this.currentModalData = modalData;

      return this.$nextTick().then(() => {
        this.$refs.modal.show();
      });
    },
  },
};
</script>
<template>
  <div :is="activeModal" v-if="activeModal" ref="modal" v-bind="modalProps" />
</template>
