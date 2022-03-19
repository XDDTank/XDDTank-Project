// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.ParticleManager

package par
{
    import flash.system.ApplicationDomain;
    import par.emitters.EmitterInfo;
    import par.emitters.Emitter;
    import par.particals.ParticleInfo;
    import par.lifeeasing.AbstractLifeEasing;
    import flash.utils.describeType;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.math.XLine;
    import road7th.math.ColorLine;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoaderEvent;

    public class ParticleManager 
    {

        public static var list:Array = new Array();
        private static var _ready:Boolean;
        public static const PARTICAL_XML_PATH:String = "partical.xml";
        public static const SHAPE_PATH:String = "shape.swf";
        public static const PARTICAL_LITE:String = "particallite.xml";
        public static const SHAPE_LITE:String = "shapelite.swf";
        internal static var Domain:ApplicationDomain;


        public static function get ready():Boolean
        {
            return (_ready);
        }

        public static function addEmitterInfo(_arg_1:EmitterInfo):void
        {
            list.push(_arg_1);
        }

        public static function removeEmitterInfo(_arg_1:EmitterInfo):void
        {
            var _local_2:int;
            while (_local_2 < list.length)
            {
                if (list[_local_2] == _arg_1)
                {
                    list.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public static function creatEmitter(_arg_1:Number):Emitter
        {
            var _local_2:EmitterInfo;
            var _local_3:Emitter;
            for each (_local_2 in list)
            {
                if (_local_2.id == _arg_1)
                {
                    _local_3 = new Emitter();
                    _local_3.info = _local_2;
                    return (_local_3);
                };
            };
            return (null);
        }

        public static function clear():void
        {
            list = new Array();
            _ready = false;
        }

        private static function load(_arg_1:XML):void
        {
            var _local_5:XML;
            var _local_6:EmitterInfo;
            var _local_7:XMLList;
            var _local_8:XML;
            var _local_9:ParticleInfo;
            var _local_10:XMLList;
            var _local_11:AbstractLifeEasing;
            var _local_12:XML;
            var _local_2:XMLList = _arg_1..emitter;
            var _local_3:XML = describeType(new ParticleInfo());
            var _local_4:XML = describeType(new EmitterInfo());
            for each (_local_5 in _local_2)
            {
                _local_6 = new EmitterInfo();
                ObjectUtils.copyPorpertiesByXML(_local_6, _local_5);
                _local_7 = _local_5.particle;
                for each (_local_8 in _local_7)
                {
                    _local_9 = new ParticleInfo();
                    ObjectUtils.copyPorpertiesByXML(_local_9, _local_8);
                    _local_10 = _local_8.easing;
                    _local_11 = new AbstractLifeEasing();
                    for each (_local_12 in _local_10)
                    {
                        if (_local_12.@name != "colorLine")
                        {
                            _local_11[_local_12.@name].line = XLine.parse(_local_12.@value);
                        }
                        else
                        {
                            _local_11.colorLine = new ColorLine();
                            _local_11.colorLine.line = XLine.parse(_local_12.@value);
                        };
                    };
                    _local_9.lifeEasing = _local_11;
                    _local_6.particales.push(_local_9);
                };
                list.push(_local_6);
            };
            _ready = true;
        }

        public static function initPartical(_arg_1:String, _arg_2:String=null):void
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:BaseLoader;
            var _local_6:ModuleLoader;
            if (((!(_ready)) && (!(_arg_1 == null))))
            {
                Domain = new ApplicationDomain();
                _local_3 = (_arg_1 + ((_arg_2 == "lite") ? PARTICAL_LITE : PARTICAL_XML_PATH));
                _local_4 = (_arg_1 + ((_arg_2 == "lite") ? SHAPE_LITE : SHAPE_PATH));
                _local_5 = LoadResourceManager.instance.createLoader(_local_3, BaseLoader.TEXT_LOADER);
                _local_5.addEventListener(LoaderEvent.COMPLETE, __loadComplete);
                LoadResourceManager.instance.startLoad(_local_5);
                _local_6 = LoadResourceManager.instance.createLoader(_local_4, BaseLoader.MODULE_LOADER, null, "GET", Domain);
                _local_6.addEventListener(LoaderEvent.COMPLETE, __onShapeLoadComplete);
                LoadResourceManager.instance.startLoad(_local_6);
            };
        }

        private static function __onShapeLoadComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, __onShapeLoadComplete);
            ShapeManager.setup();
        }

        private static function __loadComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, __loadComplete);
            try
            {
                load(new XML(_arg_1.loader.content));
            }
            catch(err:Error)
            {
            };
        }

        private static function save():XML
        {
            var _local_2:EmitterInfo;
            var _local_3:XML;
            var _local_4:ParticleInfo;
            var _local_5:XML;
            var _local_1:XML = new XML("<list></list>");
            for each (_local_2 in list)
            {
                _local_3 = ObjectUtils.encode("emitter", _local_2);
                for each (_local_4 in _local_2.particales)
                {
                    _local_5 = ObjectUtils.encode("particle", _local_4);
                    _local_5.appendChild(encodeXLine("vLine", _local_4.lifeEasing.vLine));
                    _local_5.appendChild(encodeXLine("rvLine", _local_4.lifeEasing.rvLine));
                    _local_5.appendChild(encodeXLine("spLine", _local_4.lifeEasing.spLine));
                    _local_5.appendChild(encodeXLine("sizeLine", _local_4.lifeEasing.sizeLine));
                    _local_5.appendChild(encodeXLine("weightLine", _local_4.lifeEasing.weightLine));
                    _local_5.appendChild(encodeXLine("alphaLine", _local_4.lifeEasing.alphaLine));
                    if (_local_4.lifeEasing.colorLine)
                    {
                        _local_5.appendChild(encodeXLine("colorLine", _local_4.lifeEasing.colorLine));
                    };
                    _local_3.appendChild(_local_5);
                };
                _local_1.appendChild(_local_3);
            };
            return (_local_1);
        }

        private static function encodeXLine(_arg_1:String, _arg_2:XLine):XML
        {
            return (new XML((((('<easing name="' + _arg_1) + '" value="') + XLine.ToString(_arg_2.line)) + '" />')));
        }


    }
}//package par

