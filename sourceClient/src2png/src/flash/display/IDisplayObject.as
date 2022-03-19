// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//flash.display.IDisplayObject

package flash.display
{
    import flash.events.IEventDispatcher;
    import flash.accessibility.AccessibilityProperties;
    import flash.geom.Rectangle;
    import flash.geom.Transform;
    import flash.geom.Point;

    public interface IDisplayObject extends IEventDispatcher 
    {

        function get accessibilityProperties():AccessibilityProperties;
        function set accessibilityProperties(_arg_1:AccessibilityProperties):void;
        function get alpha():Number;
        function set alpha(_arg_1:Number):void;
        function get blendMode():String;
        function set blendMode(_arg_1:String):void;
        function get cacheAsBitmap():Boolean;
        function set cacheAsBitmap(_arg_1:Boolean):void;
        function get filters():Array;
        function set filters(_arg_1:Array):void;
        function get height():Number;
        function set height(_arg_1:Number):void;
        function get loaderInfo():LoaderInfo;
        function get mask():DisplayObject;
        function set mask(_arg_1:DisplayObject):void;
        function get mouseX():Number;
        function get mouseY():Number;
        function get name():String;
        function set name(_arg_1:String):void;
        function get opaqueBackground():Object;
        function set opaqueBackground(_arg_1:Object):void;
        function get parent():DisplayObjectContainer;
        function get root():DisplayObject;
        function get rotation():Number;
        function set rotation(_arg_1:Number):void;
        function get scale9Grid():Rectangle;
        function set scale9Grid(_arg_1:Rectangle):void;
        function get scaleX():Number;
        function set scaleX(_arg_1:Number):void;
        function get scaleY():Number;
        function set scaleY(_arg_1:Number):void;
        function get scrollRect():Rectangle;
        function set scrollRect(_arg_1:Rectangle):void;
        function get stage():Stage;
        function get transform():Transform;
        function set transform(_arg_1:Transform):void;
        function get visible():Boolean;
        function set visible(_arg_1:Boolean):void;
        function get width():Number;
        function set width(_arg_1:Number):void;
        function get x():Number;
        function set x(_arg_1:Number):void;
        function get y():Number;
        function set y(_arg_1:Number):void;
        function getBounds(_arg_1:DisplayObject):Rectangle;
        function getRect(_arg_1:DisplayObject):Rectangle;
        function globalToLocal(_arg_1:Point):Point;
        function hitTestObject(_arg_1:DisplayObject):Boolean;
        function hitTestPoint(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=false):Boolean;
        function localToGlobal(_arg_1:Point):Point;
        function asDisplayObject():DisplayObject;

    }
}//package flash.display

