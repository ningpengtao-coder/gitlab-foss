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
  <pre>
    <code>
      <template v-for="(section, index) in sections">
        <div v-if="section.isHeader" :key="`header-${index}`">
          <log-line is-header :line="section" />
          <log-line v-for="line in section.lines" :key="line.offset" :line="line" />
        </div>
        <div v-else :key="index">
           <log-line v-for="line in section.lines" :key="line.offset" :line="line" />
        </div>
      </template>
    </code>
  </pre>
</template>
