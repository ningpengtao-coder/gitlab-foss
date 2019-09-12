import axios from '~/lib/utils/axios_utils';

export default {
  fetchChartData(url) {
    return axios.get(`${url}`);
  },
};
