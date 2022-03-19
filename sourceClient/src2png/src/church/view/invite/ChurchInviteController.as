// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.invite.ChurchInviteController

package church.view.invite
{
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Sprite;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import com.pickgliss.ui.LayerManager;

    public class ChurchInviteController 
    {

        private var _view:ChurchInviteView;
        private var _model:ChurchInviteModel;

        public function ChurchInviteController()
        {
            this.init();
        }

        private function init():void
        {
            this._model = new ChurchInviteModel();
            this._view = ComponentFactory.Instance.creat("church.invite.ChurchInviteView");
            this._view.controller = this;
            this._view.model = this._model;
        }

        public function getView():Sprite
        {
            return (this._view);
        }

        public function refleshList(_arg_1:int, _arg_2:int=0):void
        {
            if (_arg_1 == 0)
            {
                this.setList(0, PlayerManager.Instance.onlineFriendList);
            }
            else
            {
                if (_arg_1 == 1)
                {
                    this.setList(1, ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
                };
            };
        }

        private function isOnline(_arg_1:*):Boolean
        {
            return (_arg_1.State == 1);
        }

        private function setList(_arg_1:int, _arg_2:Array):void
        {
            this._model.setList(_arg_1, _arg_2);
        }

        public function hide():void
        {
            this._view.hide();
        }

        public function showView():void
        {
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            this._view.show();
        }

        public function dispose():void
        {
            this._model.dispose();
            this._model = null;
            if (((this._view) && (this._view.parent)))
            {
                this._view.parent.removeChild(this._view);
            };
            if (this._view)
            {
                this._view.dispose();
            };
            this._view = null;
        }


    }
}//package church.view.invite

