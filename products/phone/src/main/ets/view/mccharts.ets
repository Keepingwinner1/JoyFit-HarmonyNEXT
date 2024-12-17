
import { McLineChart, Options } from '@mcui/mccharts'
import { axisLineStyle } from '@mcui/mccharts/src/main/ets/utils/defaultOption'

@Component
export struct mcLineChart {
  @State defOption: Options = new Options({
    title: {
      show: false,
      text: '基础',
      right: 20,
      top: 30
    },
    legend: {
      show: false
    },
    tooltip: {
      show: false
    },
    xAxis:{
      data:['','','','','','',''],
      axisLine: {show: false},
      axisTick: {show: false}
    },
    yAxis:{
      axisLine: {show: false},
      axisTick: {show: false},
      splitLine: {show: false}
    },
    series:[
      {
        name:'最高气温',
        data:[46, 11, 15, 13, 12, 50, 10],
        smooth: true,
        label: {color: "#fff"},
        color: "#fff",
        areaStyle: {
          show: true,
          style: {
            opacity: 0.5
          }
        }
      }
    ]
  })
  build() {
    Row() {
      McLineChart({
        options: this.defOption
      })
    }
  }
}