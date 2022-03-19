// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road.game.resource.ActionMovieEvent

package road.game.resource
{
    import flash.events.Event;

    public class ActionMovieEvent extends Event 
    {

        public static const ACTION_START:String = "actionStart";
        public static const ACTION_END:String = "actionEnd";
        public static const EFFECT:String = "effect";

        private var _source:ActionMovie;
        private var _data:Object;

        public function ActionMovieEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1);
            if (_arg_2)
            {
                this._data = _arg_2;
            };
        }

        public function get data():Object
        {
            return (this._data);
        }

        public function get source():ActionMovie
        {
            return (super.target as ActionMovie);
        }


    }
}//package road.game.resource

