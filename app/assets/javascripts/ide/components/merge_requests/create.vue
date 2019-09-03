<script>
import $ from 'jquery';
import { mapGetters } from 'vuex';
import Icon from '../../../vue_shared/components/icon.vue';
import TitleComponent from '../../../issue_show/components/title.vue';
import DescriptionComponent from '../../../issue_show/components/description.vue';
import { setTimeout } from 'timers';

export default {
  components: {
    Icon,
    TitleComponent,
    DescriptionComponent,
  },
  computed: {

  },
  methods: {
    onload: () => {
      $('#js-create-mr-sidebar').get(0).contentDocument.body.className += '  create-merge-request-iframe'
    }
  }
};
</script>

<template>
  <div class="ide-create-merge-request d-flex flex-column h-100">
    <iframe id="js-create-mr-sidebar" src="/h5bp/html5-boilerplate/merge_requests/new?merge_request%5Bsource_branch%5D=root-master-patch-44385&amp;merge_request%5Btarget_branch%5D=master" class="h-100 border-0" style="margin: -8px -16px;" @load=onload()></iframe>
  </div>
</template>
