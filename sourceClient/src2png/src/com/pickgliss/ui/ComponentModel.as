// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.ComponentModel

package com.pickgliss.ui
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.display.Shader;
    import flash.filters.ShaderFilter;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public final class ComponentModel 
    {

        private var _allTipStyles:Vector.<String>;
        private var _bitmapSets:Dictionary;
        private var _componentStyle:Dictionary;
        private var _currentComponentSet:XML;
        private var _customObjectStyle:Dictionary;
        private var _loadedComponentSet:Vector.<String>;
        private var _shaderData:Dictionary;
        private var _styleSets:Dictionary;
        private var _allComponentSet:Dictionary;

        public function ComponentModel()
        {
            this._componentStyle = new Dictionary();
            this._customObjectStyle = new Dictionary();
            this._styleSets = new Dictionary();
            this._allTipStyles = new Vector.<String>();
            this._shaderData = new Dictionary();
            this._bitmapSets = new Dictionary();
            this._loadedComponentSet = new Vector.<String>();
            this._allComponentSet = new Dictionary();
            XML.ignoreComments = (XML.prettyPrinting = (XML.ignoreWhitespace = (XML.ignoreProcessingInstructions = false)));
            XML.prettyIndent = 0;
        }

        public function get allComponentStyle():Dictionary
        {
            return (this._componentStyle);
        }

        public function addBitmapSet(_arg_1:String, _arg_2:XML):void
        {
            this._bitmapSets[_arg_1] = _arg_2;
        }

        public function addComponentSet(_arg_1:XML):void
        {
            if (this._loadedComponentSet.indexOf(String(_arg_1.@name)) != -1)
            {
                return;
            };
            this._currentComponentSet = _arg_1;
            this._loadedComponentSet.push(String(this._currentComponentSet.@name));
            this._allComponentSet[String(_arg_1.@name)] = _arg_1;
            this.paras();
        }

        public function get allTipStyles():Vector.<String>
        {
            return (this._allTipStyles);
        }

        public function getBitmapSet(_arg_1:String):XML
        {
            return (this._bitmapSets[_arg_1]);
        }

        public function getComonentStyle(_arg_1:String):XML
        {
            return (this._componentStyle[_arg_1]);
        }

        public function getCustomObjectStyle(_arg_1:String):XML
        {
            return (this._customObjectStyle[_arg_1]);
        }

        public function getSet(_arg_1:String):*
        {
            return (this._styleSets[_arg_1]);
        }

        private function __onShaderLoadComplete(_arg_1:LoaderEvent):void
        {
            var _local_7:Array;
            var _local_2:Object = this.findShaderDataByLoader(_arg_1.loader);
            var _local_3:Shader = new Shader(_local_2.loader.content);
            var _local_4:ShaderFilter = new ShaderFilter(_local_3);
            var _local_5:Array = ComponentFactory.parasArgs(_local_2.xml.@paras);
            var _local_6:int;
            while (_local_6 < _local_5.length)
            {
                _local_7 = String(_local_5[_local_6]).split(":");
                if (_local_4.shader.data.hasOwnProperty(_local_7[0]))
                {
                    _local_4.shader.data[_local_7[0]].value = [int(_local_7[1])];
                };
                _local_6++;
            };
            this._styleSets[String(_local_2.xml.@shadername)] = _local_4;
        }

        private function findShaderDataByLoader(_arg_1:BaseLoader):Object
        {
            var _local_2:Object;
            for each (_local_2 in this._shaderData)
            {
                if (_local_2.loader == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function paras():void
        {
            this.parasSets(this._currentComponentSet..set);
            this.parasComponent(this._currentComponentSet..component);
            this.parasCustomObject(this._currentComponentSet..custom);
            if (this._currentComponentSet.hasOwnProperty("tips"))
            {
                this.parasTipStyle(this._currentComponentSet.tips);
            };
            if (this._currentComponentSet.shaderFilters.length() > 0)
            {
            };
            this.parasBitmapDataSets(this._currentComponentSet..bitmapData);
            this.parasBitmapSets(this._currentComponentSet..bitmap);
        }

        private function parasBitmapDataSets(_arg_1:XMLList):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length())
            {
                this._bitmapSets[String(_arg_1[_local_2].@resourceLink)] = _arg_1[_local_2];
                _local_2++;
            };
        }

        private function parasBitmapSets(_arg_1:XMLList):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length())
            {
                this._bitmapSets[String(_arg_1[_local_2].@resourceLink)] = _arg_1[_local_2];
                _local_2++;
            };
        }

        private function parasComponent(_arg_1:XMLList):void
        {
            var _local_3:Error;
            var _local_2:int;
            while (_local_2 < _arg_1.length())
            {
                if (this._componentStyle[String(_arg_1[_local_2].@stylename)] != null)
                {
                    _local_3 = new Error(("样式重名。。。请注意检查!!!!!!!!" + String(_arg_1[_local_2].@stylename)));
                    throw (_local_3);
                };
                _arg_1[_local_2].@componentModule = this._currentComponentSet.@name;
                this._componentStyle[String(_arg_1[_local_2].@stylename)] = _arg_1[_local_2];
                _local_2++;
            };
        }

        private function parasCustomObject(_arg_1:XMLList):void
        {
            var _local_3:Error;
            var _local_2:int;
            while (_local_2 < _arg_1.length())
            {
                if (this._customObjectStyle[String(_arg_1[_local_2].@stylename)] != null)
                {
                    _local_3 = new Error(("样式重名。。。请注意检查!!!!!!!!" + String(_arg_1[_local_2].@stylename)));
                    throw (_local_3);
                };
                this._customObjectStyle[String(_arg_1[_local_2].@stylename)] = _arg_1[_local_2];
                _local_2++;
            };
        }

        private function parasSets(_arg_1:XMLList):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.length())
            {
                if (String(_arg_1[_local_2].@type) == ClassUtils.COLOR_MATIX_FILTER)
                {
                    this._styleSets[String(_arg_1[_local_2].@stylename)] = ClassUtils.CreatInstance(_arg_1[_local_2].@type, [ComponentFactory.parasArgs(_arg_1[_local_2].@args)]);
                }
                else
                {
                    this._styleSets[String(_arg_1[_local_2].@stylename)] = ClassUtils.CreatInstance(_arg_1[_local_2].@type, ComponentFactory.parasArgs(_arg_1[_local_2].@args));
                };
                ObjectUtils.copyPorpertiesByXML(this._styleSets[String(_arg_1[_local_2].@stylename)], _arg_1[_local_2]);
                _local_2++;
            };
        }

        private function parasTipStyle(_arg_1:XMLList):void
        {
            var _local_2:Array = String(_arg_1[0].@alltips).split(",");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (this._allTipStyles.indexOf(_local_2[_local_3]) == -1)
                {
                    this._allTipStyles.push(_local_2[_local_3]);
                };
                _local_3++;
            };
        }

        public function get allComponentSet():Dictionary
        {
            return (this._allComponentSet);
        }

        public function set allComponentSet(_arg_1:Dictionary):void
        {
            this._allComponentSet = _arg_1;
        }


    }
}//package com.pickgliss.ui

