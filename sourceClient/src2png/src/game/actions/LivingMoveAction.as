// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.LivingMoveAction

package game.actions
{
    import game.objects.GameLiving;
    import game.objects.GameSmallEnemy;
    import game.animations.AnimationLevel;
    import game.GameManager;

    public class LivingMoveAction extends BaseAction 
    {

        private var _living:GameLiving;
        private var _path:Array;
        private var _currentPathIndex:int = 0;
        private var _dir:int;
        private var _endAction:String;

        public function LivingMoveAction(_arg_1:GameLiving, _arg_2:Array, _arg_3:int, _arg_4:String="")
        {
            _isFinished = false;
            this._living = _arg_1;
            this._path = _arg_2;
            this._dir = _arg_3;
            this._currentPathIndex = 0;
            this._endAction = _arg_4;
        }

        override public function prepare():void
        {
            if (this._living.isLiving)
            {
                this._living.startMoving();
                if (((!(this._living is GameSmallEnemy)) || (this._living == this._living.map.currentFocusedLiving)))
                {
                    this._living.needFocus(0, 0, {
                        "strategy":"directly",
                        "priority":AnimationLevel.LOW
                    });
                };
                if (this._path[0].x < this._path[(this._path.length - 1)].x)
                {
                    this._living.actionMovie.scaleX = -1;
                }
                else
                {
                    if (this._path[0].x > this._path[(this._path.length - 1)].x)
                    {
                        this._living.actionMovie.scaleX = 1;
                    };
                };
            }
            else
            {
                this.finish();
            };
        }

        override public function execute():void
        {
            if ((this._living is GameSmallEnemy))
            {
                if (((!(GameManager.Instance.isSingleDungeonRoom())) || (!(this._living.map.getContains(this._living.x, this._living.y)))))
                {
                    this._living.map.requestForFocus(this._living, AnimationLevel.LOW);
                };
            }
            else
            {
                this._living.needFocus(0, 0, {
                    "strategy":"directly",
                    "priority":AnimationLevel.MIDDLE
                });
            };
            if (this._path[this._currentPathIndex])
            {
                this._living.info.pos = this._path[this._currentPathIndex];
            };
            this._currentPathIndex++;
            if (this._currentPathIndex >= this._path.length)
            {
                this.finish();
                if (this._endAction != "")
                {
                    this._living.doAction(this._endAction);
                }
                else
                {
                    this._living.info.doDefaultAction();
                };
            };
        }

        private function finish():void
        {
            this._living.stopMoving();
            _isFinished = true;
        }

        override public function cancel():void
        {
            _isFinished = true;
        }


    }
}//package game.actions

