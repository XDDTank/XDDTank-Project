// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.actions.SkillActions.SkillAction

package game.actions.SkillActions
{
    import game.actions.BaseAction;
    import game.animations.IAnimate;

    public class SkillAction extends BaseAction 
    {

        private var _animate:IAnimate;
        private var _onComplete:Function;
        private var _onCompleteParams:Array;

        public function SkillAction(_arg_1:IAnimate, _arg_2:Function=null, _arg_3:Array=null)
        {
            this._animate = _arg_1;
            this._onComplete = _arg_2;
            this._onCompleteParams = _arg_3;
        }

        override public function execute():void
        {
            if (this._animate != null)
            {
                if (this._animate.finish)
                {
                    if (this._onComplete != null)
                    {
                        this._onComplete.apply(null, this._onCompleteParams);
                    };
                    this.finish();
                };
            }
            else
            {
                this.finish();
            };
        }

        protected function finish():void
        {
            _isFinished = true;
        }


    }
}//package game.actions.SkillActions

