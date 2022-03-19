// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemMainView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import totem.TotemManager;
    import road7th.comm.PackageIn;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import totem.data.TotemEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemMainView extends Sprite implements Disposeable 
    {

        private var _leftView:TotemLeftView;
        private var _bg:Bitmap;

        public function TotemMainView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.totemViewBg");
            this._leftView = ComponentFactory.Instance.creatCustomObject("totemLeftView");
            addChild(this._bg);
            addChild(this._leftView);
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOTEM, this.refresh);
        }

        private function refresh(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:Boolean;
            TotemManager.instance.isLast = false;
            TotemManager.instance.isUpgrade = false;
            var _local_2:PackageIn = _arg_1.pkg;
            PlayerManager.Instance.Self.GP = _local_2.readInt();
            PlayerManager.Instance.Self.totemScores = _local_2.readInt();
            var _local_3:int = _local_2.readInt();
            if (_local_3 == PlayerManager.Instance.Self.totemId)
            {
                _local_4 = false;
                SoundManager.instance.play("202");
            }
            else
            {
                SoundManager.instance.play("201");
                _local_4 = true;
                TotemManager.instance.isUpgrade = true;
                if (((_local_3 - 10000) % 7) == 0)
                {
                    TotemManager.instance.isLast = true;
                };
                PlayerManager.Instance.Self.totemId = _local_3;
                TotemManager.instance.updatePropertyAddtion(PlayerManager.Instance.Self.totemId, PlayerManager.Instance.Self.propertyAddition);
                PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_PLAYER_PROPERTY));
            };
            this._leftView.refreshView(_local_4);
            TotemManager.instance.dispatchEvent(new TotemEvent(TotemEvent.TOTEM_UPDATE));
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOTEM, this.refresh);
        }

        public function showUserGuilde():void
        {
            this._leftView.showUserGuilde();
        }

        public function dispose():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._leftView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

