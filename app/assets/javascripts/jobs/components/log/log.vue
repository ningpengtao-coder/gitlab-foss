<script>
import Vue from 'vue';
import LogLine from './line.vue';
import LogLineHeader from './line_header.vue';
import linesParser from '../../store/utils';
import log from '../../mock_data/trace';

export default {
  components: {
    LogLine,
    LogLineHeader,
  },
  data() {
    return {
      sections: linesParser(log.lines),
      jobPath: document.location.href, // TODO
    };
  },
  methods: {
    handleOnClickCollapsibleLine(section) {
      Vue.set(section, 'isClosed', !section.isClosed);
    },
  },
};
</script>
<template>
  <code class="job-log">
    <template v-for="(section, index) in sections">
      <template v-if="section.isHeader">
        <log-line-header
          :key="`collapsible-${index}`"
          :line="section.line"
          :path="jobPath"
          :is-closed="section.isClosed"
          @toggleLine="handleOnClickCollapsibleLine(section)"
        />
        <template v-if="!section.isClosed">
          <log-line v-for="line in section.lines" :key="line.offset" :line="line" :path="jobPath" />
        </template>
      </template>
      <log-line v-else :key="section.offset" :line="section" :path="jobPath" />
    </template>
  </code>
</template>