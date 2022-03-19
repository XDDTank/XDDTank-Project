// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.importSym

package cmodule.decry
{
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.text.*;
    import flash.net.*;
    import flash.system.*;

    public function importSym(s:String):int
    {
        var res:int = gstate.syms[s];
        if ((!(res)))
        {
            log(3, ("Undefined sym: " + s));
            return (exportSym(s, regFunc(function ():*
            {
                throw ("Undefined sym: " + s);
            })));
        };
        return (res);
    }

}//package cmodule.decry

