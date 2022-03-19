// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.LayerManager

package com.pickgliss.ui
{
    import com.pickgliss.ui.core.SpriteLayer;
    import flash.display.Stage;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.DisplayUtils;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.Sprite;

    public class LayerManager 
    {

        public static const STAGE_TOP_LAYER:int = 0;
        public static const STAGE_DYANMIC_LAYER:int = 1;
        public static const GAME_TOP_LAYER:int = 2;
        public static const GAME_DYNAMIC_LAYER:int = 3;
        public static const GAME_UI_LAYER:int = 4;
        public static const GAME_BASE_LAYER:int = 5;
        public static const GAME_BOTTOM_LAYER:int = 6;
        public static const STAGE_BOTTOM_LAYER:int = 7;
        public static const NONE_BLOCKGOUND:int = 0;
        public static const BLCAK_BLOCKGOUND:int = 1;
        public static const ALPHA_BLOCKGOUND:int = 2;
        private static var _instance:LayerManager;

        private var _stageTopLayer:SpriteLayer;
        private var _stageDynamicLayer:SpriteLayer;
        private var _stageBottomLayer:SpriteLayer;
        private var _gameTopLayer:SpriteLayer;
        private var _gameDynamicLayer:SpriteLayer;
        private var _gameUILayer:SpriteLayer;
        private var _gameBaseLayer:SpriteLayer;
        private var _gameBottomLayer:SpriteLayer;


        public static function get Instance():LayerManager
        {
            if (_instance == null)
            {
                _instance = new (LayerManager)();
            };
            return (_instance);
        }


        public function setup(_arg_1:Stage):void
        {
            this._stageTopLayer = new SpriteLayer();
            this._stageDynamicLayer = new SpriteLayer();
            this._stageBottomLayer = new SpriteLayer(true);
            this._gameTopLayer = new SpriteLayer();
            this._gameDynamicLayer = new SpriteLayer();
            this._gameUILayer = new SpriteLayer();
            this._gameBaseLayer = new SpriteLayer();
            this._gameBottomLayer = new SpriteLayer();
            _arg_1.addChild(this._stageBottomLayer);
            _arg_1.addChild(this._stageDynamicLayer);
            _arg_1.addChild(this._stageTopLayer);
            this._gameDynamicLayer.autoClickTotop = true;
            this._stageBottomLayer.addChild(this._gameBottomLayer);
            this._stageBottomLayer.addChild(this._gameBaseLayer);
            this._stageBottomLayer.addChild(this._gameUILayer);
            this._stageBottomLayer.addChild(this._gameDynamicLayer);
            this._stageBottomLayer.addChild(this._gameTopLayer);
        }

        public function getLayerByType(_arg_1:int):SpriteLayer
        {
            switch (_arg_1)
            {
                case STAGE_TOP_LAYER:
                    return (this._stageTopLayer);
                case STAGE_DYANMIC_LAYER:
                    return (this._stageDynamicLayer);
                case GAME_TOP_LAYER:
                    return (this._gameTopLayer);
                case GAME_DYNAMIC_LAYER:
                    return (this._gameDynamicLayer);
                case GAME_BASE_LAYER:
                    return (this._gameBaseLayer);
                case GAME_BOTTOM_LAYER:
                    return (this._gameBottomLayer);
                case GAME_UI_LAYER:
                    return (this._gameUILayer);
                case STAGE_BOTTOM_LAYER:
                    return (this._stageBottomLayer);
            };
            return (null);
        }

        public function addToLayer(_arg_1:DisplayObject, _arg_2:int, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=true):void
        {
            var _local_7:Rectangle;
            var _local_6:SpriteLayer = this.getLayerByType(_arg_2);
            if (_arg_3)
            {
                if ((_arg_1 is Component))
                {
                    _arg_1.x = ((StageReferance.stageWidth - _arg_1.width) / 2);
                    _arg_1.y = ((StageReferance.stageHeight - _arg_1.height) / 2);
                }
                else
                {
                    _local_7 = DisplayUtils.getVisibleSize(_arg_1);
                    _arg_1.x = ((StageReferance.stageWidth - _local_7.width) / 2);
                    _arg_1.y = ((StageReferance.stageHeight - _local_7.height) / 2);
                };
            };
            _local_6.addTolayer(_arg_1, _arg_4, _arg_5);
        }

        public function clearnStageDynamic():void
        {
            this.cleanSprite(this._stageDynamicLayer);
        }

        public function clearnGameDynamic():void
        {
            this.cleanSprite(this._gameDynamicLayer);
        }

        public function clearnGameTop():void
        {
            this.cleanSprite(this._gameTopLayer);
        }

        private function cleanSprite(_arg_1:Sprite):void
        {
            var _local_2:DisplayObject;
            while (_arg_1.numChildren > 0)
            {
                _local_2 = _arg_1.getChildAt(0);
                ObjectUtils.disposeObject(_local_2);
            };
        }

        public function get backGroundInParent():Boolean
        {
            if (((((((((!(this._stageTopLayer.backGroundInParent)) && (!(this._stageDynamicLayer.backGroundInParent))) && (!(this._stageBottomLayer.backGroundInParent))) && (!(this._gameTopLayer.backGroundInParent))) && (!(this._gameDynamicLayer.backGroundInParent))) && (!(this._gameUILayer.backGroundInParent))) && (!(this._gameBaseLayer.backGroundInParent))) && (!(this._gameBottomLayer.backGroundInParent))))
            {
                return (false);
            };
            return (true);
        }


    }
}//package com.pickgliss.ui

