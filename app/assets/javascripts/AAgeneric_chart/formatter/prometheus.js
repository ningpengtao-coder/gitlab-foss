{
  source: {
    $path: 'data.result[]',
      name: {
      $path: '$item.metric.job',
    },
    data: {
      $path: '$item.values[]',
        $formatting(item) {
        return [item[1], item[0] * Math.random()*1000];
      },
    },
  },
}