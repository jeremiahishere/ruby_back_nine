_.templateSettings.interpolate = /\{\{(.+?)\}\}/g //Nicer template tags
$(function(){
  var Solution = Backbone.Model.extend({});
  var TestCase = Backbone.Model.extend({});
  
  var Hole = Backbone.Model.extend({
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
        var url = '/API/holes/' + (self.id ? '?course_id='+self.id : '');
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
    list_template: _.template("<a class='open' href='javascript:void(0);'>{{name}}</a>"),
    events: {
      "click .open": "open"
    },
    open: function() {
      var hole = new Hole({id: this.model.get('id')});
      this.listenTo(hole, "change", function(){
        var view = new HoleView({model: hole, template_name: 'details'});
        app.holeDetail(view);
      });
      hole.fetch();
    },
    initialize: function(options) {
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
      var self = this;
      this.collection.each(function(hole){
        var holeView = new HoleView({model: hole, template_name: 'list', tagName: 'li'})
        self.$el.append(holeView.render().el);
      })
      console.log("Render holes")
      return self;
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
      console.log("open")
      var course = new Course({id: this.model.get('id')});
      var self = this;
      this.listenTo(course, "change", function(){
        var view = new CourseView({model: course, template_name: 'details'});
        app.courseDetail(view);
      });
      course.fetch();
    },
    initialize: function(options) {
      this.listenTo(this.model, "change", this.render);
      this.template = this[options.template_name+'_template'];
      this.holesView = new HolesView({collection: this.model.get('holes'), template_name: 'list'});
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      this.$('ul.holes').html(this.holesView.render().el);
      
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