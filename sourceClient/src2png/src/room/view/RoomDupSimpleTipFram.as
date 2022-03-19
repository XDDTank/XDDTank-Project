// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomDupSimpleTipFram

package room.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.LayerManager;

    public class RoomDupSimpleTipFram extends BaseAlerFrame 
    {

        private var _view:Sprite;
        private var _bg:Bitmap;
        private var _dupTip:FilterFrameText;
        private var _newEnemy:FilterFrameText;
        private var _boguBoss:FilterFrameText;
        private var _moreGoods:FilterFrameText;
        private var _goodsI:FilterFrameText;
        private var _goodsII:FilterFrameText;
        private var _goodsIII:FilterFrameText;
        private var _goodsIV:FilterFrameText;

        public function RoomDupSimpleTipFram()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._view = new Sprite();
            this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.BoGuTipAsset");
            this._dupTip = ComponentFactory.Instance.creatComponentByStylename("room.BoGuTip");
            this._boguBoss = ComponentFactory.Instance.creatComponentByStylename("room.BoGuBoss");
            this._newEnemy = ComponentFactory.Instance.creatComponentByStylename("room.BoGuNewEnemy");
            this._moreGoods = ComponentFactory.Instance.creatComponentByStylename("room.BoGuMoreGoods");
            this._goodsI = ComponentFactory.Instance.creatComponentByStylename("room.BoGuGoodsI");
            this._goodsII = ComponentFactory.Instance.creatComponentByStylename("room.BoGuGoodsII");
            this._goodsIII = ComponentFactory.Instance.creatComponentByStylename("room.BoGuGoodsIII");
            this._goodsIV = ComponentFactory.Instance.creatComponentByStylename("room.BoGuGoodsIV");
            this._dupTip.text = LanguageMgr.GetTranslation("ddt.room.boguTip");
            this._newEnemy.text = LanguageMgr.GetTranslation("ddt.room.boguNewEnemy");
            this._boguBoss.text = LanguageMgr.GetTranslation("ddt.room.boguBoss");
            this._moreGoods.text = LanguageMgr.GetTranslation("ddt.room.boguMoreGoods");
            this._goodsI.text = LanguageMgr.GetTranslation("ddt.room.boguGoods1");
            this._goodsII.text = LanguageMgr.GetTranslation("ddt.room.boguGoods2");
            this._goodsIII.text = LanguageMgr.GetTranslation("ddt.room.boguGoods3");
            this._goodsIV.text = LanguageMgr.GetTranslation("ddt.room.boguGoods4");
            this._view.addChild(this._bg);
            this._view.addChild(this._dupTip);
            this._view.addChild(this._newEnemy);
            this._view.addChild(this._boguBoss);
            this._view.addChild(this._moreGoods);
            this._view.addChild(this._goodsI);
            this._view.addChild(this._goodsII);
            this._view.addChild(this._goodsIII);
            this._view.addChild(this._goodsIV);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        public function show():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.data = this._view;
            _local_1.showCancel = false;
            _local_1.moveEnable = false;
            info = _local_1;
            addToContent(this._view);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            super.dispose();
            this._view = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

