// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.BossThumbnail

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import game.model.Living;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.filters.BitmapFilter;
    import com.pickgliss.ui.ComponentFactory;
    import room.RoomManager;
    import worldboss.WorldBossManager;
    import worldboss.event.WorldBossRoomEvent;
    import flash.geom.Point;
    import ddt.events.LivingEvent;
    import flash.events.Event;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.utils.ObjectUtils;
    import game.model.SimpleBoss;
    import flash.filters.ColorMatrixFilter;
    import worldboss.view.WorldBossCutHpMC;
    import ddt.utils.PositionUtils;

    public class BossThumbnail extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _living:Living;
        private var _headFigure:HeadFigure;
        private var _blood:BossBloodItem;
        private var _name:FilterFrameText;
        private var isFirst:Boolean = true;
        private var lightingFilter:BitmapFilter;

        public function BossThumbnail(_arg_1:Living)
        {
            this._living = _arg_1;
            this.init();
            this.initEvents();
        }

        public function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossThumbnailBgAsset");
            addChild(this._bg);
            if (RoomManager.Instance.current.type == 14)
            {
                this._blood = new BossBloodItem(WorldBossManager.Instance.bossInfo.total_Blood);
                WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA, this.__showCutHp);
                this._blood.bloodNum = WorldBossManager.Instance.bossInfo.current_Blood;
            }
            else
            {
                this._blood = new BossBloodItem(this._living.maxBlood);
                this.__updateBlood(null);
            };
            addChild(this._blood);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("room.bossThumbnailHPPos");
            this._blood.x = _local_1.x;
            this._blood.y = _local_1.y;
            this._name = ComponentFactory.Instance.creatComponentByStylename("asset.game.bossThumbnailNameTxt");
            addChild(this._name);
            this._name.text = this._living.name;
        }

        public function initEvents():void
        {
            if (this._living)
            {
                this._living.addEventListener(LivingEvent.BLOOD_CHANGED, this.__updateBlood);
                this._living.addEventListener(LivingEvent.DIE, this.__die);
            };
            this.addEventListener(Event.ENTER_FRAME, this.__changeIcon);
        }

        private function __changeIcon(_arg_1:Event):void
        {
            if (((ModuleLoader.hasDefinition(this._living.actionMovieName)) && (this.isFirst)))
            {
                ObjectUtils.disposeObject(this._headFigure);
                this._headFigure = null;
                this._headFigure = new HeadFigure(62, 62, this._living);
                addChild(this._headFigure);
                this._headFigure.y = 11;
                this._headFigure.x = 4;
                this.isFirst = false;
                this.removeEventListener(Event.ENTER_FRAME, this.__changeIcon);
            };
        }

        public function __updateBlood(_arg_1:LivingEvent):void
        {
            if (RoomManager.Instance.current.type != 14)
            {
                this._blood.bloodNum = this._living.blood;
            };
            if (this._living.blood <= 0)
            {
                if (this._headFigure)
                {
                    this._headFigure.gray();
                };
            };
        }

        public function __die(_arg_1:LivingEvent):void
        {
            if (this._headFigure)
            {
                this._headFigure.gray();
            };
            if (this._blood)
            {
                this._blood.visible = false;
            };
        }

        private function __shineChange(_arg_1:LivingEvent):void
        {
            var _local_2:SimpleBoss = (this._living as SimpleBoss);
            if (((_local_2) && (_local_2.isAttacking)))
            {
            };
        }

        public function setUpLintingFilter():void
        {
            var _local_1:Array = new Array();
            _local_1 = _local_1.concat([1, 0, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 1, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 1, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 0, 1, 0]);
            this.lightingFilter = new ColorMatrixFilter(_local_1);
        }

        public function removeEvents():void
        {
            WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA, this.__showCutHp);
            if (this._living)
            {
                this._living.removeEventListener(LivingEvent.BLOOD_CHANGED, this.__updateBlood);
                this._living.removeEventListener(LivingEvent.DIE, this.__die);
            };
            this.removeEventListener(Event.ENTER_FRAME, this.__changeIcon);
        }

        public function updateView():void
        {
            if ((!(this._living)))
            {
                this.visible = false;
            }
            else
            {
                if (this._headFigure)
                {
                    this._headFigure.dispose();
                    this._headFigure = null;
                };
                if (this._blood)
                {
                    this._blood = null;
                };
                this.init();
            };
        }

        public function set info(_arg_1:Living):void
        {
            if ((!(_arg_1)))
            {
                this.removeEvents();
            };
            this._living = _arg_1;
            this.updateView();
        }

        public function get Id():int
        {
            if ((!(this._living)))
            {
                return (-1);
            };
            return (this._living.LivingID);
        }

        private function __showCutHp(_arg_1:WorldBossRoomEvent):void
        {
            if (WorldBossManager.Instance.bossInfo.cutValue <= 0)
            {
                return;
            };
            if (this._blood)
            {
                this._blood.updateBlood(WorldBossManager.Instance.bossInfo.current_Blood, WorldBossManager.Instance.bossInfo.total_Blood);
            };
            var _local_2:WorldBossCutHpMC = new WorldBossCutHpMC(WorldBossManager.Instance.bossInfo.cutValue);
            PositionUtils.setPos(_local_2, "fightBoss.numMC.pos");
            addChildAt(_local_2, 0);
        }

        private function offset(_arg_1:int=30):int
        {
            var _local_2:int = int((Math.random() * 10));
            if ((_local_2 % 2) == 0)
            {
                return (-(int((Math.random() * _arg_1))));
            };
            return (int((Math.random() * _arg_1)));
        }

        public function dispose():void
        {
            this.removeEvents();
            removeChild(this._bg);
            this._bg.bitmapData.dispose();
            this._bg = null;
            this._living = null;
            if (this._headFigure)
            {
                this._headFigure.dispose();
                this._headFigure = null;
            };
            this._blood.dispose();
            this._blood = null;
            this._name.dispose();
            this._name = null;
            this.lightingFilter = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.playerThumbnail

