<script>
import $ from 'jquery';
import { mapGetters, mapState } from 'vuex';
import Icon from '../../../vue_shared/components/icon.vue';
import TitleComponent from '../../../issue_show/components/title.vue';
import DescriptionComponent from '../../../issue_show/components/description.vue';
import { setTimeout, setInterval, clearInterval } from 'timers';

export default {
  components: {
    Icon,
    TitleComponent,
    DescriptionComponent,
  },
  computed: {
    ...mapState(['currentBranchId', 'currentProjectId', 'currentMergeRequestId']),

    mergeRequestSrc() {
      if (this.currentMergeRequestId) {
        return `/${this.currentProjectId}/merge_requests/${this.currentMergeRequestId}`;
      }
      return `/${this.currentProjectId}/merge_requests/new?merge_request%5Bsource_branch%5D=${this.currentBranchId}&amp;merge_request%5Btarget_branch%5D=master`;
    }
  },
  methods: {
    onload: () => {

    }
  },
  mounted: () => {
    let i = setInterval(() => {
      try {
        if ($('#js-create-mr-sidebar').get(0).contentWindow.location.href === 'about:blank') return;

        $('#js-create-mr-sidebar').get(0).contentDocument.body.className += '  create-merge-request-iframe';
        clearInterval(i);
        console.log()
      }
      catch (e) {}
    }, 1000 / 60)

    setTimeout(clearInterval, 10000, i)
  }
};
</script>

<template>
  <div class="ide-create-merge-request d-flex flex-column h-100">
    <iframe
      id="js-create-mr-sidebar"
      :src="mergeRequestSrc"
      class="h-100 border-0"
      style="margin: -8px -16px;"
      @load=onload()>
    </iframe>
  </div>
</template>
