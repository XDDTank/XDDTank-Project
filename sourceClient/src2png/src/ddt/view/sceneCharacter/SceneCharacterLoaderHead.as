﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterLoaderHead

package ddt.view.sceneCharacter
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import flash.display.BlendMode;
    import ddt.view.character.ILayer;
    import __AS3__.vec.*;

    public class SceneCharacterLoaderHead 
    {

        private var _loaders:Vector.<SceneCharacterLayer>;
        private var _recordStyle:Array;
        private var _recordColor:Array;
        private var _content:BitmapData;
        private var _completeCount:int;
        private var _playerInfo:PlayerInfo;
        private var _isAllLoadSucceed:Boolean = true;
        private var _callBack:Function;

        public function SceneCharacterLoaderHead(_arg_1:PlayerInfo)
        {
            this._playerInfo = _arg_1;
        }

        public function load(_arg_1:Function=null):void
        {
            this._callBack = _arg_1;
            if (((this._playerInfo == null) || (this._playerInfo.Style == null)))
            {
                return;
            };
            this.initLoaders();
            var _local_2:int = this._loaders.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._loaders[_local_3].load(this.layerComplete);
                _local_3++;
            };
        }

        private function initLoaders():void
        {
            this._loaders = new Vector.<SceneCharacterLayer>();
            this._recordStyle = this._playerInfo.Style.split(",");
            this._recordColor = this._playerInfo.Colors.split(",");
            this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])), this._recordColor[5]));
            this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])), this._recordColor[2]));
            this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])), this._recordColor[3]));
        }

        private function drawCharacter():void
        {
            var _local_4:SceneCharacterLayer;
            var _local_1:Number = this._loaders[0].width;
            var _local_2:Number = this._loaders[0].height;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            this._content = new BitmapData(_local_1, _local_2, true, 0);
            var _local_3:uint;
            while (_local_3 < this._loaders.length)
            {
                _local_4 = this._loaders[_local_3];
                if ((!(_local_4.isAllLoadSucceed)))
                {
                    this._isAllLoadSucceed = false;
                };
                this._content.draw(_local_4.getContent(), null, null, BlendMode.NORMAL);
                _local_3++;
            };
        }

        private function layerComplete(_arg_1:ILayer):void
        {
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._loaders.length)
            {
                if ((!(this._loaders[_local_3].isComplete)))
                {
                    _local_2 = false;
                };
                _local_3++;
            };
            if (_local_2)
            {
                this.drawCharacter();
                this.loadComplete();
            };
        }

        private function loadComplete():void
        {
            if (this._callBack != null)
            {
                this._callBack(this, this._isAllLoadSucceed);
            };
        }

        public function getContent():Array
        {
            return ([this._content]);
        }

        public function dispose():void
        {
            if (this._loaders == null)
            {
                return;
            };
            var _local_1:int;
            while (_local_1 < this._loaders.length)
            {
                this._loaders[_local_1].dispose();
                _local_1++;
            };
            this._loaders = null;
            this._recordStyle = null;
            this._recordColor = null;
            this._playerInfo = null;
            this._callBack = null;
        }


    }
}//package ddt.view.sceneCharacter
