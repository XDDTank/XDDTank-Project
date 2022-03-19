// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.StateIconButton

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.list.IDropListTarget;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.data.player.PlayerState;
    import ddt.manager.SocketManager;
    import flash.display.DisplayObject;

    public class StateIconButton extends Sprite implements IDropListTarget, Disposeable 
    {

        private var _btn:BaseButton;
        private var _stateIcon:ScaleFrameImage;

        public function StateIconButton()
        {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("IMView.selectStateBtn");
            addChild(this._btn);
            this._stateIcon = ComponentFactory.Instance.creatComponentByStylename("im.stateIcon");
            this._stateIcon.setFrame(PlayerManager.Instance.Self.playerState.StateID);
            this._stateIcon.mouseEnabled = (this._stateIcon.mouseChildren = false);
            addChild(this._stateIcon);
        }

        public function setCursor(_arg_1:int):void
        {
            this._stateIcon.setFrame(_arg_1);
        }

        public function setFrame(_arg_1:int):void
        {
            this._stateIcon.setFrame(_arg_1);
        }

        public function get caretIndex():int
        {
            return (0);
        }

        public function setValue(_arg_1:*):void
        {
            this._stateIcon.setFrame(PlayerState(_arg_1).StateID);
            if (PlayerManager.Instance.Self.playerState.StateID != PlayerState(_arg_1).StateID)
            {
                SocketManager.Instance.out.sendFriendState(PlayerState(_arg_1).StateID);
            };
            PlayerManager.Instance.Self.playerState = _arg_1;
        }

        public function getValueLength():int
        {
            return (0);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
        }


    }
}//package im

