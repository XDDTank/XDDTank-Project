// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.menu.MenuPanel

package church.view.menu
{
    import flash.display.Sprite;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.ChurchManager;
    import ddt.data.ChurchRoomInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;

    public class MenuPanel extends Sprite 
    {

        public static const STARTPOS:int = 10;
        public static const STARTPOS_OFSET:int = 18;
        public static const GUEST_X:int = 9;
        public static const THIS_X_OFSET:int = 95;
        public static const THIS_Y_OFSET:int = 55;

        private var _info:PlayerInfo;
        private var _kickGuest:MenuItem;
        private var _blackGuest:MenuItem;
        private var _bg:ScaleBitmapImage;

        public function MenuPanel()
        {
            var _local_1:Number;
            super();
            this._bg = ComponentFactory.Instance.creat("church.weddingRoom.guestListMenuBg");
            addChildAt(this._bg, 0);
            _local_1 = STARTPOS;
            this._kickGuest = new MenuItem(LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom"));
            this._kickGuest.x = GUEST_X;
            this._kickGuest.y = _local_1;
            _local_1 = (_local_1 + STARTPOS_OFSET);
            this._kickGuest.addEventListener("menuClick", this.__menuClick);
            addChild(this._kickGuest);
            this._blackGuest = new MenuItem(LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.btnText"));
            this._blackGuest.x = GUEST_X;
            this._blackGuest.y = _local_1;
            _local_1 = (_local_1 + STARTPOS_OFSET);
            this._blackGuest.addEventListener("menuClick", this.__menuClick);
            addChild(this._blackGuest);
            graphics.beginFill(0, 0);
            graphics.drawRect(-3000, -3000, 6000, 6000);
            graphics.endFill();
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
        }

        public function set playerInfo(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.hide();
        }

        private function __menuClick(_arg_1:Event):void
        {
            if (ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.menu.MenuPanel.menuClick"));
                return;
            };
            if (this._info)
            {
                switch (_arg_1.currentTarget)
                {
                    case this._kickGuest:
                        SocketManager.Instance.out.sendChurchKick(this._info.ID);
                        return;
                    case this._blackGuest:
                        SocketManager.Instance.out.sendChurchForbid(this._info.ID);
                        return;
                };
            };
        }

        public function show():void
        {
            var _local_1:Point;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER);
            if (((stage) && (parent)))
            {
                _local_1 = parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
                this.x = _local_1.x;
                this.y = _local_1.y;
                if ((x + THIS_X_OFSET) > stage.stageWidth)
                {
                    this.x = (x - THIS_X_OFSET);
                };
                if ((y + THIS_Y_OFSET) > stage.stageHeight)
                {
                    y = (stage.stageHeight - THIS_Y_OFSET);
                };
            };
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function dispose():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._blackGuest.removeEventListener("menuClick", this.__menuClick);
            this._info = null;
            if (((this._kickGuest) && (this._kickGuest.parent)))
            {
                this._kickGuest.parent.removeChild(this._kickGuest);
            };
            if (this._kickGuest)
            {
                this._kickGuest.dispose();
            };
            this._kickGuest = null;
            if (((this._blackGuest) && (this._blackGuest.parent)))
            {
                this._blackGuest.parent.removeChild(this._blackGuest);
            };
            if (this._blackGuest)
            {
                this._blackGuest.dispose();
            };
            this._blackGuest = null;
            if (this._bg)
            {
                if (this._bg.parent)
                {
                    this._bg.parent.removeChild(this._bg);
                };
                this._bg.dispose();
            };
            this._bg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.menu

