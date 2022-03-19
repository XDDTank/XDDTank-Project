// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.states.FadingBlock

package ddt.states
{
    import flash.display.Sprite;
    import ddt.manager.StateManager;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import flash.utils.getTimer;
    import com.pickgliss.loader.LoaderSavingManager;

    public class FadingBlock extends Sprite 
    {

        private var _func:Function;
        private var _life:Number;
        private var _exected:Boolean;
        private var _nextView:BaseStateView;
        private var _showLoading:Function;
        private var _newStart:Boolean;
        private var _showed:Boolean;
        private var _canSave:Boolean;

        public function FadingBlock(_arg_1:Function, _arg_2:Function)
        {
            this._func = _arg_1;
            this._showLoading = _arg_2;
            this._life = 0;
            this._newStart = true;
            this._canSave = true;
            graphics.beginFill(0);
            graphics.drawRect(0, 0, 1008, 608);
            graphics.endFill();
        }

        public function setNextState(_arg_1:BaseStateView):void
        {
            this._nextView = _arg_1;
            this._canSave = (!(StateManager.currentStateType == StateType.LOGIN));
        }

        public function update():void
        {
            if (parent == null)
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, 0, false);
            };
            if (this._newStart)
            {
                if (StateManager.isShowFadingAnimation)
                {
                    alpha = 0;
                    this._life = 0;
                }
                else
                {
                    this._func();
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                    dispatchEvent(new Event(Event.COMPLETE));
                    this._nextView.fadingComplete();
                    return;
                };
                this._exected = false;
                this._showed = false;
                addEventListener(Event.ENTER_FRAME, this.__enterFrame);
            }
            else
            {
                this._life = 1;
                alpha = this._life;
                this._exected = false;
            };
            this._newStart = false;
        }

        public function stopImidily():void
        {
            parent.removeChild(this);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            this._newStart = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function set executed(_arg_1:Boolean):void
        {
            this._exected = _arg_1;
        }

        private function __enterFrame(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:Number;
            if (this._life < 1)
            {
                this._life = (this._life + 0.16);
                alpha = this._life;
            }
            else
            {
                if (this._life < 2)
                {
                    _local_2 = getTimer();
                    if (this._canSave)
                    {
                        LoaderSavingManager.saveFilesToLocal();
                    };
                    _local_2 = (getTimer() - _local_2);
                    _local_3 = ((_local_2 / 40) * 0.1);
                    this._life = (this._life + ((_local_3 < 0.1) ? 0.1 : _local_3));
                    if (this._life > 2)
                    {
                        this._life = 2.01;
                    };
                    if ((!(this._exected)))
                    {
                        this._exected = true;
                        alpha = 1;
                        this._func();
                    };
                }
                else
                {
                    if (this._life >= 2)
                    {
                        this._life = (this._life + 0.16);
                        alpha = (3 - this._life);
                        if (alpha < 0.2)
                        {
                            if (parent)
                            {
                                parent.removeChild(this);
                            };
                            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                            this._newStart = true;
                            dispatchEvent(new Event(Event.COMPLETE));
                            this._nextView.fadingComplete();
                        };
                    };
                };
            };
        }


    }
}//package ddt.states

