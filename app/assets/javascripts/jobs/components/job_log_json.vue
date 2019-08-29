<script>
import log from '../mock_data/trace';
import { linesParser } from '../store/utils';
import LogLine from './job_line.vue';

export default {
  name: 'JobLogJSON',
  components: {
    LogLine,
  },
  data() {
    return {
      sections: linesParser(log.lines),
      currentPath: document.location.href
    };
  },

  methods: {
    isCollpasibleSection(line) {
      return line.section_header;
    },
  },
};
</script>
<template>
  <pre class="">
    <template v-for="(section, index) in sections">
      <div v-if="section.isHeader" :key="`header-${index}`">
        <log-line v-for="line in section.lines" :key="line.offset" :line="line" :current-path="currentPath"/>
      </div><log-line v-else :line="section" :key="section.offset" :current-path="currentPath"/>
    </template>
  </pre>
</template>
