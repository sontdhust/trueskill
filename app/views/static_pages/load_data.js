$("#matches tbody").empty();
<% for match in @matches %>
  $("#matches tbody").append($('<tr>').prop('class', "<%= match.predict == match.result ? 'good-comparison' : 'bad-comparison' %>")
    .append($('<td>').prop('class', 'match-home').text("<%== match.home.name %>"))
    .append($('<td>').prop('class', 'match-away').text("<%== match.away.name %>"))
    .append($('<td>').prop('class', 'match-predict').text("<%= match.predict %>"))
    .append($('<td>').prop('class', 'match-result').text("<%= match.result %>"))
    .append($('<td>').prop('class', 'match-date').text("<%= match.date %>"))
  );
<% end %>
$("#current-season").text('Season: ' + "<%= session[:current_year] %>" + '-' + "<%= session[:current_year] + 1 %>");
$("#load-data").prop("disabled", "<%= session[:calculated] %>" == 'true' ? false : true);
$("#calculate-season").prop("disabled", "<%= session[:calculated] %>" == 'true' ? true : false);
$("#correct-prediction").text("<%= @correct_prediction %>");
