// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatBasePanel

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.ui.LayerManager;

    public class ChatBasePanel extends Sprite 
    {

        public function ChatBasePanel()
        {
            this.init();
            this.initEvent();
        }

        protected function init():void
        {
            graphics.beginFill(0, 0);
            graphics.drawRect(-3000, -3000, 6000, 6000);
            graphics.endFill();
        }

        protected function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__hideThis);
        }

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__hideThis);
        }

        protected function __hideThis(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.setVisible = false;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function set setVisible(_arg_1:Boolean):void
        {
            if (((visible == true) && (_arg_1 == false)))
            {
                ShowTipManager.Instance.removeCurrentTip();
            };
            if (_arg_1)
            {
                LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false, 0, false);
            }
            else
            {
                if (parent)
                {
                    parent.removeChild(this);
                };
            };
        }


    }
}//package ddt.view.chat

