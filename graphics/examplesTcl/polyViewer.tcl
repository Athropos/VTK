## Create a little app for loading and viewing polygonal files
##
source TkInteractor.tcl

# Create gui
frame .mbar -relief raised -bd 2
pack .mbar -side top -fill x

menubutton .mbar.file -text File -menu .mbar.file.menu
menubutton .mbar.view -text View -menu .mbar.view.menu
menubutton .mbar.help -text Help -menu .mbar.help.menu
pack .mbar.file .mbar.view -side left
pack .mbar.help -side right

menu .mbar.file.menu
    .mbar.file.menu add command -label Open -command OpenFile
    .mbar.file.menu add command -label Exit -command exit

set view Left
menu .mbar.view.menu
    .mbar.view.menu add radiobutton -label Front -variable view -value Front\
            -command {UpdateView 1 0 0 0 1 0}
    .mbar.view.menu add radiobutton -label Back -variable view -value Back\
            -command {UpdateView -1 0 0 0 1 0}
    .mbar.view.menu add radiobutton -label Left -variable view -value Left\
            -command {UpdateView 0 0 1 0 1 0}
    .mbar.view.menu add radiobutton -label Right -variable view -value Right\
            -command {UpdateView 0 0 -1 0 1 0}
    .mbar.view.menu add radiobutton -label Top -variable view -value Top\
            -command {UpdateView 0 1 0 0 0 1}
    .mbar.view.menu add radiobutton -label Bottom -variable view -value Bottom\
            -command {UpdateView 0 -1 0 0 0 1}
    .mbar.view.menu add radiobutton -label Isometric -variable view \
        -value Isometric -command {UpdateView 1 1 1 0 1 0}

menu .mbar.help.menu
    .mbar.help.menu add command -label {Buy a book!}

vtkTkRenderWidget .window -width 300 -height 300 
    BindTkRenderWidget .window
pack .window -side top -anchor nw -padx 3 -pady 3 -fill both -expand 1

# Procedure to set particular views
proc UpdateView {x y z vx vy vz} {
    global ren renWin

    set camera [$ren GetActiveCamera]
    $camera SetViewPlaneNormal $x $y $z
    $camera SetViewUp $vx $vy $vz
    $ren ResetCamera
    Render
}

# Procedure opens file and resets view
proc OpenFile {} {
    global ren renWin reader

    set types {
        {{BYU}                                  {.g}          }
        {{Stereo-Lithography}                   {.stl}        }
        {{Visualization Toolkit (polygonal)}    {.vtk}        }
        {{All Files }                           *             }
    }
    set filename [tk_getOpenFile -filetypes $types]
    if { $filename != "" } {
        $ren RemoveActors bannerActor
        $ren RemoveActors actor
        if { [string match *.g $filename] } {
            set reader byu
            byu SetGeometryFilename $filename
        } elseif { [string match *.stl $filename] } {
            set reader stl
            stl SetFilename $filename
        } elseif { [string match *.vtk $filename] } {
            set reader vtk
            vtk SetFilename $filename
        } else {
            puts "Can't read this file"
            return
        }
        
        mapper SetInput [$reader GetOutput]
        $reader Update
        if { [[$reader GetOutput] GetNumberOfCells] <= 0 } {
            $ren AddActors bannerActor
        } else {
            $ren AddActors actor
        }
        $ren ResetCamera
        $renWin Render
    }
}

# Create pipeline
set reader stl
vtkSTLReader stl
vtkBYUReader byu
vtkPolyReader vtk
vtkPolyMapper   mapper
vtkActor actor
    actor SetMapper mapper

vtkVectorText banner
    banner SetText "      vtk\nStereo-Lithography\n     Viewer"
vtkPolyMapper bannerMapper
    bannerMapper SetInput [banner GetOutput]
vtkActor bannerActor
    bannerActor SetMapper bannerMapper

set renWin [.window GetRenderWindow]
set ren   [$renWin MakeRenderer]

$ren AddActors bannerActor
[$ren GetActiveCamera] Zoom 1.25
