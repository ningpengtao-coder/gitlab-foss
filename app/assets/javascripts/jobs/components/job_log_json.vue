<script>
import Vue from 'vue';
import log from '../mock_data/trace';
import linesParser from '../store/utils';
import LogLine from './log/line.vue';
import LogLineHeader from './log/line_header.vue';

export default {
  name: 'JobLogJSON',
  props: {
    isComplete: {
      type: Boolean,
      required: true,
    },
  },
  components: {
    LogLine,
    LogLineHeader,
  },
  data() {
    return {
      sections: linesParser(log.lines),
      currentPath: document.location.href, // TODO
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
  <pre class="job-log">
    <template v-for="(section, index) in sections">
      <div v-if="section.isHeader" :key="`header-${index}`">
        <log-line-header
  :key="`log-header-${index}`"
  :line="section.line"
  :path="currentPath"
  @toggleLine="handleOnClickCollapsibleLine(section)"
  :is-closed="section.isClosed"
/>
        <template v-if="!section.isClosed">
          <log-line
  v-for="line in section.lines"
  :key="line.offset"
  :line="line"
  :path="currentPath"
/>
        </template>
      </div><log-line
  v-else
  :line="section"
  :key="section.offset"
  :path="currentPath"
/>
    </template>
  </pre>
</template>
