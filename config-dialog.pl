#!/usr/bin/perl
#
# conf.
#
# Copyright (C) 2008 mdl <mdomlop at gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


(my $program_name = $0) =~ s#.*/##g;
my $height		= 640;
my $width		= 512;
my $home		= $ENV{HOME};
my $config		= "$ARGV[0]"; # Si se pasa un argumento se ejecuta $0 $config, si no, un menú (zenity, gtkperl) y se ejecuta $0 $config.
my $usered		= "gvim";
my $rooted		= "gksu gvim";
my $configrc		= "$home/.config/configrc";
my $listview		= "zenity --list --title \"Configurador\" --text \"Elige un archivo de configuración.\" --column \"Programas:\" --column \"Archivos:\" `cat $configrc` --width $width --height $height";


if (!$config) { $config = `$listview` or exit 0; system("$0 $config"); }

open(CONFIG, "<$configrc") or die "No puedo leer el archivo $config\n";

for(<CONFIG>) {
$_ =~ s/\$HOME/$home/g; # para que se pueda usar $HOME en el archivo de configuración
my ($entry, $file) = $_ =~ /(\S+)\s+(\S+)/;
if ("$entry" eq "$config") { edit("$file"); last}
}

close(CONFIG) or die "No puedo cerrar el archivo $config\n";



sub edit {
my $config = "$_[0]";
if (-w $config)	{ system("$usered $config") }
#FIXME: if (! -e ) Si no existe el fichero (por un error en el configrc, por ej.) carga el siguiente else:
else		{ system("$rooted $config") }
}
