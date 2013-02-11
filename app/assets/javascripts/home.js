var whenever;

$(document).ready(function(){
  var submit_show = function(){
    $('.submit.hide').toggle();
  }
  $('.show_solution_submit').click(submit_show);

  var TestCase = Backbone.Model.extend({
  });
  
  var Solution = Backbone.Model.extend({
  });
  
  var Hole = Backbone.Model.extend({
    
    defaults: function() {
      return {
        name: "new hole...",
        creator: "the-team@cloudspace.com",
        par: 1,
        max_exec: 1,
        description: "An unfinished hole.",
        sample_test_case: new TestCase(),
        sample_solution: new Solution()
      };
    },
    url : function() {
      return '/API' + (this.id ? '/holes/' + this.id : '/holes'); 
    },
    
    // Ensure that each hole has defaults in place
    initialize: function() {
    },
    
  });
  
  var HoleList = Backbone.Collection.extend({
    model: Hole
  });
  
  var Course = Backbone.Model.extend({
    defaults: function() {
      return {
        name: "new course...",
        creator: "the-team@cloudspace.com",
        start_at: new Date(),
        end_at: new Date(+new Date + 12096e5),
        description: "An unfinished course.",
        holes: new HoleList()
      };
    },
    initialize: function() {

    },
    url: function() {
      return '/API' + (this.id ? '/courses/' + this.id : '/courses'); 
    }
  });
  
  var CourseList = Backbone.Collection.extend({
    model: Course
  });
  
  var CourseView = Backbone.View.extend({
    tagName: "div",
    className: "course",
    events: {
      "click .open": "open"
    },
    open: function() {
      console.log("Click open!");
    },
    initialize: function() {
      this.listenTo(this.model, "change", this.render);
    },
    render: function() {
      console.log("render");
      this.$el.html("<li>\
        <div class='course'>\
          <div class='head'>\
            <div class='title'>\
              <span class='name'><a href='javascript:void(0);' class='open'>"+this.model.get("name")+"</a></span>\
              <span class='hole-count'> - "+this.model.get("name")+" hole,</span>\
              <span class='par'>par "+this.model.get("par")+"</span>\
            </div>\
            <div class='dates'>\
              <div class='end'>Closes on "+this.model.get("end_at")+"</div>\
            </div>\
            <div class='clearfix'></div>\
          </div>\
          <div class='description'>"+this.model.get("description")+"</div>\
        </div>\
      </li>");
      return this;
    }
  })
  
  
  var AppView = Backbone.View.extend({
    el: $('#rubygolf')
  });
  
  var c = new Course({id: 1});
  whenever = new CourseView({model: c, el: $("ul.courses")});
  c.fetch();
  
  //console.log(mHole);
  
})

