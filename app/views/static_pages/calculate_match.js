<% unless @teams.nil? %>
  $("#teams tbody").empty();
  <% for team in @teams %>
    $("#teams tbody").append($('<tr>').prop('class', "<%= team.old_mean.nil? ? '' : (team.mean > team.old_mean ? 'good-comparison' : team.mean < team.old_mean ? 'bad-comparison' : '') %>")
      .append($('<td>').prop('class', 'team-name').text("<%== team.name %>"))
      .append($('<td>').prop('class', 'team-current-rating').text("<%= team.mean.round(2).to_s + ' ±' + team.standard_deviation.round(2).to_s %>"))
      .append($('<td>').prop('class', 'team-old-rating').text("<%= team.old_mean && team.old_standard_deviation && team.old_mean.round(2).to_s + ' ±' + team.old_standard_deviation.round(2).to_s %>"))
    );
  <% end %>
<% end %>
var data = new FormData();
data.append('home', $("#home").val());
data.append('away', $("#away").val());
$.ajax({
  url: "<%= predict_match_path %>",
  type: "PUT",
  processData: false,
  contentType: false,
  dataType : 'script',
  data: data
});