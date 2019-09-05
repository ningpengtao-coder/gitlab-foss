import axios from '~/lib/utils/axios_utils';
// eslint-disable-next-line global-require
const sampleData = require('./../sample_data/data.json');

export default {
  fetchChartData(url) {
    if (Math.random() < 0.5) {
      return Promise.resolve(sampleData);

    }
    return axios.get(`${url}`);
  }
};
