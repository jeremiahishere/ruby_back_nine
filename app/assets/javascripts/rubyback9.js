_.templateSettings.interpolate = /\{\{(.+?)\}\}/g //Nicer template tags
$(function(){
  
  /* Models */
  var Solution = Backbone.Model.extend({
    url: function() {
      return '/API' + (this.id? '/solutions/' +this.id : '/solutions')
    }
  });
  var Hole = Backbone.Model.extend({
    url : function() {
      return '/API' + (this.id ? '/holes/' + this.id : '/holes'); 
    }
  });
  var Course = Backbone.Model.extend({
    url: function() {
      return '/API' + (this.id ? '/courses/' + this.id : '/courses'); 
    }
  });
  
  /* Collections */
  var HoleList = Backbone.Collection.extend({
    model: Hole,
    initialize: function(models, options){
      this.course_id = options.course_id;
    },
    url: function() {
      return '/API/holes?course_id='+this.course_id; 
    }
  });
  var CourseList = Backbone.Collection.extend({
    model: Course,
    url: function() {
      return '/API/courses'; 
    }
  });
  
  /* Views */
  var CourseListItemView = Backbone.View.extend({
    tagName: 'li',
    className: 'course',
    template: _.template($('#courselistitem-template').html()),
    events: {
      "click .open-course" : "open"
    },
    open: function() {
      var activeCourse = new Course({id: this.model.get('id')});
      var courseDetail = new CourseDetailView({model: activeCourse});
      $('#message').show();
      activeCourse.fetch();
      $('li.course').removeClass('active');
      this.$el.addClass('active');
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.listenTo(this.model, 'change', this.render)
    }
  });
  var CourseDetailView = Backbone.View.extend({
    el: $('#course .course'),
    template: _.template($('#coursedetail-template').html()),
    render: function() {
      
      $('#hole').empty();
      $('#course .course').empty();
      $('ul.holes').empty();
      
      this.$el.html(this.template(this.model.toJSON()));
      
      this.holes.each(function(hole){
        var holeListItem = new HoleListItemView({model: hole});
        $('ul.holes').append(holeListItem.render().el);
      });
      
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.holes = new HoleList({}, {course_id: this.model.get('id')});
      
      this.listenTo(this.model, 'change', this.render);
      this.listenTo(this.holes, 'reset', this.render)
      $('#message').show();
      this.holes.fetch();
    }
  });
  var HoleListItemView = Backbone.View.extend({
    tagName: "li",
    className: "hole",
    template: _.template($('#holelistitem-template').html()),
    events: {
      "click .open-hole" : "open"
    },
    open: function() {
      var activeHole = new Hole({id: this.model.get('id')});
      var holeDetail = new HoleDetailView({model: activeHole});
      $('#message').show();
      activeHole.fetch();
      $('li.hole').removeClass('active');
      this.$el.addClass('active');
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.listenTo(this.model, 'change', this.render)
    }
  });
  var HoleDetailView = Backbone.View.extend({
    el: $('#hole'),
    template: _.template($('#holedetail-template').html()),
    solution_template: _.template($('#solution-template').html()),
    events: {
      "click .submit" : "submitSolution"
    },
    submitSolution: function() {
      $('.solution .input').hide();
      $('.solution .progress').show();
      
      var solution = new Solution({
        code: $('.solution .input textarea').val(),
        hole_id: this.model.get('id')
      });
      
      this.listenTo(solution, 'change', function(solution){
        $('.solution .output').html(this.solution_template(solution.toJSON()));
        $('.solution .progress').hide();
      });
      solution.save();
    },
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      $('#message').hide();
      return this;
    },
    initialize: function() {
      this.listenTo(this.model, 'change', this.render)
    }
  });
  var AppView = Backbone.View.extend({
    el: $('#application'),
    initialize: function() {
      var courses = new CourseList;
      this.listenTo(courses, 'reset', this.start);
      $('#message').show();
      courses.fetch();
    },
    start: function(courses) {
      courses.each(function(course){
        var courseListItem = new CourseListItemView({model: course});
        $('ul.courses').append(courseListItem.render().el);
      }, this);
    }
  })
  
  var app = new AppView;
});