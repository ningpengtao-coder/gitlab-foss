interface DataSource {
  chartType: ChartType;
  chartOptions: ChartOptions;
  source: SourceEntity[];
}

export interface ChartOptions {
  xAxis:  {
    name: string;
    type: AxisType
  };
}

export interface SourceEntity {
  name?: string;
  data: number[]
}

enum ChartType {
  "column",
  "line",
  "area"
}

enum AxisType {
  "value",
  "category",
  "time",
  "log"
}
