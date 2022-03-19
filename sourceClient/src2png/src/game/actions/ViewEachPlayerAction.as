// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.ViewEachPlayerAction

package game.actions
{
    import game.view.map.MapView;
    import game.GameManager;
    import game.animations.AnimationLevel;
    import game.animations.AnimationSet;

    public class ViewEachPlayerAction extends BaseAction 
    {

        private var _map:MapView;
        private var _players:Array;
        private var _interval:Number;
        private var _index:int;
        private var _count:int;

        public function ViewEachPlayerAction(_arg_1:MapView, _arg_2:Array, _arg_3:Number=1500)
        {
            this._players = _arg_2.sortOn("x", Array.NUMERIC);
            this._map = _arg_1;
            this._interval = (_arg_3 / 40);
            this._index = 0;
            this._count = 0;
        }

        override public function execute():void
        {
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            if (this._count <= 0)
            {
                if (this._index < this._players.length)
                {
                    this._map.setCenter(this._players[this._index].x, (this._players[this._index].y - 150), true, AnimationLevel.MIDDLE, AnimationSet.PUBLIC_OWNER);
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

