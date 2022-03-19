// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ViewEachObjectAction

package game.actions
{
    import game.view.map.MapView;

    public class ViewEachObjectAction extends BaseAction 
    {

        private var _map:MapView;
        private var _objects:Array;
        private var _interval:Number;
        private var _index:int;
        private var _count:int;
        private var _type:int;

        public function ViewEachObjectAction(_arg_1:MapView, _arg_2:Array, _arg_3:int=0, _arg_4:Number=1500)
        {
            this._objects = _arg_2;
            this._map = _arg_1;
            this._interval = (_arg_4 / 40);
            this._index = 0;
            this._count = 0;
            this._type = _arg_3;
        }

        override public function execute():void
        {
            if (this._count <= 0)
            {
                if (this._index < this._objects.length)
                {
                    this._map.scenarioSetCenter(this._objects[this._index].x, this._objects[this._index].y, this._type);
                    this._count = this._interval;
                    this._index++;
                }
                else
                {
                    _isFinished = true;
                };
            };
            this._count--;
        }


    }
}//package game.actions

