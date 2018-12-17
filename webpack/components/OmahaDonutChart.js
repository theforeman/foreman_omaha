import React from 'react';
import PropTypes from 'prop-types';
import { map, get } from 'lodash';
// eslint-disable-next-line import/no-extraneous-dependencies, import/no-unresolved, import/extensions
import DonutChart from 'foremanReact/components/common/charts/DonutChart';

const OmahaDonutChart = ({ data: { columns, search } }) => {
  map(columns, c => {
    if (c[2]) {
      c[2] = get($.pfPaletteColors, c[2], $.pfPaletteColors.blue);
    }
    return c;
  });

  return (
    <DonutChart
      data={columns}
      config="small"
      onclick={e => {
        if (search && search[e.id]) {
          window.location.href = search[e.id];
        }
      }}
    />
  );
};

OmahaDonutChart.propTypes = {
  data: PropTypes.object.isRequired,
};

export default OmahaDonutChart;
