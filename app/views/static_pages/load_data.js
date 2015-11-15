$("#matches tbody").empty();
var cp = 0;
var mc = 0;
<% for match in @matches %>
  $("#matches tbody").append($('<tr>').prop('class', "<%= match.predict == match.result ? 'good-comparison' : 'bad-comparison' %>")
    .append($('<td>').prop('class', 'match-home').text("<%== match.home.name %>"))
    .append($('<td>').prop('class', 'match-away').text("<%== match.away.name %>"))
    .append($('<td>').prop('class', 'match-predict').text("<%= match.predict %>"))
    .append($('<td>').prop('class', 'match-result').text("<%= match.result %>"))
    .append($('<td>').prop('class', 'match-date').text("<%= match.date %>"))
  );
  <% if match.predict == match.result %>
    cp++;
  <% end %>
  mc++;
<% end %>
$("#current-season").text('Season: ' + "<%= session[:current_year] %>" + '-' + "<%= session[:current_year] + 1 %>");
$("#load-data").prop("disabled", "<%= session[:calculated] %>" == 'true' ? false : true);
$("#calculate-season").prop("disabled", "<%= session[:calculated] %>" == 'true' ? true : false);
$("#correct-prediction").text('Correct prediction: ' + (cp / mc * 100).toFixed(2) + '%');
