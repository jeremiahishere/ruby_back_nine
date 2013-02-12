//_.templateSettings.interpolate = /\{\{(.+?)\}\}/g //Nicer template tags

$(function(){
  var TestCase = Backbone.Model.extend({});
  var Solution = Backbone.Model.extend({});
  
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
    }
  });
  
  var HoleList = Backbone.Collection.extend({
    model: Hole,
    url: function() {
      return '/API/holes'; 
    }
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
      this.set('holes', new HoleList());
      var self = this;
      this.get('holes').url = function () {
        console.log("Get url for " + self.id);
        var url = '/API/holes/' + (self.id ? '?course_id='+self.id : '');
        console.log(url);
        return url;
      };
      
      this.get('holes').fetch();
    },
    url: function() {
      return '/API' + (this.id ? '/courses/' + this.id : '/courses'); 
    }
  });
  
  var CourseList = Backbone.Collection.extend({
    model: Course,
    url: function() {
      return '/API/courses'; 
    }
  });
  
  var HoleView = Backbone.View.extend({
    details_template: _.template($('#templates .hole_detail').html()),
    list_template: _.template("<li><a class='open' href='javascript:void(0);'>{{name}}</a></li>"),
    events: {
      "click .open": "open"
    },
    open: function() {
      console.log("Click open for "+this.model.id);
      var view = new HoleView({model: this.model, template_name: 'details'});
      app.holeDetail(view);
    },
    initialize: function(options) {
      this.listenTo(this.model, "change", this.render);
      this.template = this[options.template_name+'_template'];
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  })
  
  var HolesView = Backbone.View.extend({
    tagName: "ul",
    className: "holes",
    render: function() {
      this.$el.html("");
      this.collection.each(function(hole){
        this.$el.append("<li class='hole'>"+hole.get("name")+"</li>")
      })
    }
  });
  
  var CoursesView = Backbone.View.extend({
    tagName: "ul",
    className: "courses",
    render: function() {
      this.$el.html("");
      this.collection.each(function(course) {
          var view = new CourseView({ model: course, template_name: 'list', tagName: 'li'});
          this.$el.append(view.render().el);          
      }, this);
      return this;
    }
  })
  
  var CourseView = Backbone.View.extend({
    details_template: _.template($('#templates .course_detail').html()),
    list_template: _.template($('#templates .course_list').html()),
    events: {
      "click .open": "open"
    },
    open: function() {
      console.log("Click open for "+this.model.id);
      var view = new CourseView({model: this.model, template_name: 'details'});
      app.courseDetail(view);
    },
    initialize: function(options) {
      this.listenTo(this.model, "change", this.render);
      this.template = this[options.template_name+'_template'];
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      console.log(this.model.toJSON());
      return this;
    }
  })
  var courses = new CourseList();
  
  var AppView = Backbone.View.extend({
    el: $('#rubygolf'),
    initialize: function() {
      this.listenTo(courses, 'reset', this.listCourses);
      courses.fetch();
    },
    listCourses: function(){
      var list_view = new CoursesView({collection: courses});
      this.$('#payload').html(list_view.render().el);
      this.$('h2.page_title').html("Active Courses");
    },
    courseDetail: function(courseView){
      this.$('#payload').html(courseView.render().el);
      this.$('h2.page_title').html(courseView.model.get("name"));
    },
    holeDetail: function(holeView){
      this.$('#payload').html(holeView.render().el);
      this.$('h2.page_title').html(holeView.model.get("name"));
    }
  });

  var app = new AppView();
})